//
//  ClusterManager.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 06/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

// MARK: Utility Functions
private func zoomScaleToZoomLevel(scale: Double) -> Int {
    let totalTilesAtMaxZoom = MKMapSizeWorld.width/256.0
    let zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom)
    let zoomLevel = max(0, Float(zoomLevelAtMaxZoom) + floor(log2f(Float(scale)) + 0.5))
    
    return Int(zoomLevel)
}

private func cellSizeForZoomScale(scale: Double) -> Double {
    let zoomLevel = zoomScaleToZoomLevel(scale)
    
    switch zoomLevel {

    case 13,14,15:
        return 64
        
    case 16,17,18:
        return 32
        
    case 19:
        return 16
        
    default:
        return 88
    }
}

// MARK: ClusterManagerDelegate
protocol ClusterManagerDelegate {
    func cellSizeFactorForManager(manager: ClusterManager) -> Double
}

// MARK: ClusterManager class
public class ClusterManager: NSObject {
    
    var delegate: ClusterManagerDelegate? = nil
    
    private var tree: Tree? = Tree()
    private var lock: NSRecursiveLock
    
    public init(annotations: [MapAnnotation]) {
        lock = NSRecursiveLock()
        
        super.init()
        
        addAnnotations(annotations)
        
    }
    
    func setAnnotations(annotations: [MapAnnotation]) {
        tree = nil
        
    }
    
    func addAnnotations(annotations: [MapAnnotation]) {
        lock.lock()
        
        for annotation in annotations {
            tree?.insertAnnotaion(annotation)
        }
        
        lock.unlock()
    }
    
    func removeAnnotations(annotations: [MapAnnotation]) {
        if tree == nil {
            return
        }
        
        lock.lock()
        
        for annotation in annotations {
            tree?.removeAnnotation(annotation)
        }
        
        lock.unlock()
    }
    
    public func clusteredAnnotationsWithinMapRect(rect: MKMapRect, zoomScale: Double) -> [AnyObject]{
        return clusteredAnnotationsWithinMapRect(rect, zoomScale: zoomScale, filter: nil)
    }
    
    func clusteredAnnotationsWithinMapRect(rect: MKMapRect, zoomScale: Double, filter: ((annotation: MapAnnotation) -> Bool)?) -> [AnyObject] {
        var cellSize = cellSizeForZoomScale(zoomScale)
        
        if let sizeMultiplier = delegate?.cellSizeFactorForManager(self){
            cellSize *= sizeMultiplier
        }
        
        let scaleFactor = Double(zoomScale / cellSize)
        
        let minX = floor(MKMapRectGetMinX(rect) * Double(scaleFactor))
        let maxX = floor(MKMapRectGetMaxX(rect) * Double(scaleFactor))
        let minY = floor(MKMapRectGetMinY(rect) * Double(scaleFactor))
        let maxY = floor(MKMapRectGetMaxY(rect) * Double(scaleFactor))
        
        var clusteredAnnotations = [AnyObject]()
        
        lock.lock()

        for var x = minX; x <= maxX; x++ {
            for  var y = minY; y <= maxY; y++ {
                let mapRect = MKMapRectMake(x/scaleFactor, y/scaleFactor, 1.0/scaleFactor, 1.0/scaleFactor)
                let mapBox = BoundingBox.BoundingBoxForMapRect(mapRect)
                
                var totalLatitude: Double = 0
                var totalLongitude: Double = 0
                
                var annotations = [AnyObject]()
                
                tree?.enumerateAnnotationsInBox(mapBox, block: { annotation in

                    if filter == nil || filter!(annotation: annotation) == true {
                        totalLatitude += annotation.coordinate.latitude
                        totalLongitude += annotation.coordinate.longitude
                        annotations.append(annotation)
                    }
                })
                
                let count = annotations.count
                if count == 1 {
                    clusteredAnnotations.appendContentsOf(annotations)
                }
                
                if count > 1 {
                    let coordinate = CLLocationCoordinate2DMake(totalLatitude/Double(count), totalLongitude/Double(count))
                    let cluster = ClusterAnnotation(coordinate: coordinate)
                    cluster.annotations = annotations as! [MapAnnotation]
                    clusteredAnnotations.append(cluster)
                }
            }
        }
        
        lock.unlock()
        
        return clusteredAnnotations
    }
    
    func allAnnotations() -> [MapAnnotation] {
        var annotations = [MapAnnotation]()
        
        lock.lock()
        
        tree?.enumerateAnnotationsUsingBlock( { annotation in
            annotations.append(annotation)
        })
        
        lock.unlock()
        
        return annotations
    }
    
    public func displayAnnotations(annotations: [MapAnnotation], allAnnotations: [MapAnnotation], mapView: MKMapView) {
        let before = Set<MapAnnotation>(allAnnotations)
        
        let after = Set<MapAnnotation>(annotations)
        
        let toKeep = before.intersect(after)
        
        let toAdd = after.subtract(toKeep)
        
        let toRemove = before.subtract(after)
        
        dispatch_async(dispatch_get_main_queue(), {
            var toAddArray = [MapAnnotation]()
            for annotation in toAdd {
                toAddArray.append(annotation)
            }
            mapView.addAnnotations(toAddArray)
            
            var toRemoveArray = [MapAnnotation]()
            for annotation in toRemove {
                toRemoveArray.append(annotation)
            }
            mapView.removeAnnotations(toRemoveArray)
        })
        
    }
    
}

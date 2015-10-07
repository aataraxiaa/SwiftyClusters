//
//  TreeNode.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 05/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

 /**
*  The Bounding Box struct
*/
struct BoundingBox {
    var x0: Double
    var y0: Double
    var xf: Double
    var yf: Double
    
    static func BoundingBoxForMapRect(mapRect: MKMapRect) -> BoundingBox {
        let topLeft = MKCoordinateForMapPoint(mapRect.origin)
        let bottomRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)))
        
        let minLat = bottomRight.latitude
        let maxLat = topLeft.latitude
        
        let minLon = topLeft.longitude
        let maxLon = bottomRight.longitude
        
        return BoundingBox(x0: minLat, y0: minLon, xf: maxLat, yf: maxLon)
    }
    
    static func MapRectForBoundingBox(boundingBox: BoundingBox) -> MKMapRect {
        let topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0))
        let bottomRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf))
        
        return MKMapRectMake(topLeft.x, bottomRight.y, fabs(bottomRight.x - topLeft.x), fabs(bottomRight.y - topLeft.y))
    }
    
    static func BoundingBoxContainsCoordinate(boundingBox: BoundingBox, coordinate: CLLocationCoordinate2D) -> Bool {
        let containsX = boundingBox.x0 <= coordinate.latitude && coordinate.latitude <= boundingBox.xf
        let containsY = boundingBox.y0 <= coordinate.longitude && coordinate.longitude <= boundingBox.yf
        
        return containsX && containsY
    }
    
    static func BoundingBoxIntersectsBoundingBox(box1: BoundingBox, box2: BoundingBox) -> Bool {
        return (box1.x0 <= box2.xf && box1.xf >= box2.x0 && box1.y0 <= box2.yf && box1.yf >= box2.y0)
    }
}

/**
*  TreeNode class
*/
class TreeNode: NSObject {
    
    static let nodeCapacity = 8
    
    var count = 0
    var boundingBox: BoundingBox? = nil
    
    var annotations = [MapAnnotation]()
    
    var northEast: TreeNode? = nil
    var northWest: TreeNode? = nil
    var southEast: TreeNode? = nil
    var southWest: TreeNode? = nil
    
    init(box: BoundingBox?) {
        super.init()
        self.boundingBox = box
    }
    
    func isLeaf() -> Bool {
        return self.northEast == nil ? true : false
    }
    
    func subdivide() {
        northEast = TreeNode(box: nil)
        northWest = TreeNode(box: nil)
        southEast = TreeNode(box: nil)
        southWest = TreeNode(box: nil)
        
        let box = boundingBox
        let xMid = ((box?.xf)! + (box?.x0)!) / 2.0
        let yMid = ((box?.yf)! + (box?.y0)!) / 2.0
        
        northEast?.boundingBox = BoundingBox(x0: xMid, y0: (box?.y0)!, xf: (box?.xf)!, yf: yMid)
        northWest?.boundingBox = BoundingBox(x0: (box?.x0)!, y0: (box?.y0)!, xf: xMid, yf: yMid)
        southEast?.boundingBox = BoundingBox(x0: xMid, y0: yMid, xf: (box?.xf)!, yf: (box?.yf)!)
        southWest?.boundingBox = BoundingBox(x0: (box?.x0)!, y0: yMid, xf: xMid, yf: (box?.yf)!)
    }
}

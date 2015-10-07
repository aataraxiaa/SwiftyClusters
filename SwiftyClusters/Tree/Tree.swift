//
//  Tree.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 06/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

class Tree: NSObject {

    var rootNode: TreeNode
    
    override init() {
        rootNode = TreeNode(box: BoundingBox.BoundingBoxForMapRect(MKMapRectWorld))
        super.init()
    }
    
    func insertAnnotaion(annotation: MapAnnotation) -> Bool {
        return insertAnnotationToNode(annotation, node: rootNode)
    }
    
    private func insertAnnotationToNode(annotation: MapAnnotation, node: TreeNode) -> Bool {
        if !(BoundingBox.BoundingBoxContainsCoordinate(node.boundingBox!, coordinate: annotation.coordinate)) {
            return false
        }
        
        if node.count < TreeNode.nodeCapacity {
            node.annotations.append(annotation)
            return true
        }
        
        if insertAnnotationToNode(annotation, node: node.northEast!) {
            return true
        }
        
        if insertAnnotationToNode(annotation, node: node.northWest!) {
            return true
        }
        
        if insertAnnotationToNode(annotation, node: node.southEast!) {
            return true
        }
        
        if insertAnnotationToNode(annotation, node: node.southWest!) {
            return true
        }
        
        return false
    }
    
    func removeAnnotation(annotation: MapAnnotation) -> Bool {
        return removeAnnotationFromNode(annotation, node: rootNode)
    }
    
    private func removeAnnotationFromNode(annotation: MapAnnotation, node: TreeNode) -> Bool {
        if !(BoundingBox.BoundingBoxContainsCoordinate(node.boundingBox!, coordinate: annotation.coordinate)) {
            return false
        }

        if node.annotations.contains(annotation) {
            node.annotations.removeAtIndex(node.annotations.indexOf(annotation)!)
            node.count--
            return true
        }
        
        if removeAnnotationFromNode(annotation, node: node.northEast!) {
            return true
        }
        
        if removeAnnotationFromNode(annotation, node: node.northWest!) {
            return true
        }
        
        if removeAnnotationFromNode(annotation, node: node.southEast!) {
            return true
        }
        
        if removeAnnotationFromNode(annotation, node: node.southWest!) {
            return true
        }
            
        return false
    }

    func enumerateAnnotationsInBox(box: BoundingBox, block: ((annotation: MapAnnotation) -> Void)) {
        enumerateAnnotationInBox(box, node: rootNode, block: block)
    }
    
    func enumerateAnnotationsUsingBlock(block: ((annotation: MapAnnotation) -> Void)) {
        enumerateAnnotationInBox(BoundingBox.BoundingBoxForMapRect(MKMapRectWorld), node: rootNode, block: block)
    }
    
    func enumerateAnnotationInBox(box: BoundingBox, node: TreeNode, block: ((annotation: MapAnnotation) -> Void)) {
        if !(BoundingBox.BoundingBoxIntersectsBoundingBox(node.boundingBox!, box2: box)) {
            return
        }
        
        let tempArray = node.annotations
        
        for annotation in tempArray {
            if BoundingBox.BoundingBoxContainsCoordinate(box, coordinate: annotation.coordinate) {
                block(annotation: annotation)
            }
        }
        
        if node.isLeaf() {
            return
        }
        
        enumerateAnnotationInBox(box, node: node.northEast!, block: block)
        enumerateAnnotationInBox(box, node: node.northWest!, block: block)
        enumerateAnnotationInBox(box, node: node.southEast!, block: block)
        enumerateAnnotationInBox(box, node: node.southWest!, block: block)
    }
}

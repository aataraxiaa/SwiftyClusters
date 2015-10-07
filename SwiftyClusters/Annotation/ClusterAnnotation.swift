//
//  ClusterAnnotation.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 05/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

/// Class used to display cluster annotations on a map
public class ClusterAnnotation: MapAnnotation {
    
    // The annotations associated with this annotation cluster
    public var annotations: [MapAnnotation]! = nil
}

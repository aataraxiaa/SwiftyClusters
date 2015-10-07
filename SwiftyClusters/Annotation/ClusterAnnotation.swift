//
//  ClusterAnnotation.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 05/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

/// Class used to display cluster annotations on a map
class ClusterAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    var title: String? = nil
    var subtitle: String? = nil
    
    // The annotations associated with this annotation cluster
    var annotations: [SingleAnnotation]! = nil
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

//
//  SingleAnnotation.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 06/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

class SingleAnnotation: NSObject, MKAnnotation {
    var title :String? = ""
    var subtitle :String? = ""
    let coordinate:CLLocationCoordinate2D
    
    override var hashValue: Int {
        get {
            return self.calculateHashValue()
        }
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    private func calculateHashValue() -> Int {
        let prime:Int = 7
        var result:Int = 1
        let toHash = NSString(format: "c[%.8f,%.8f]", coordinate.latitude, coordinate.longitude)
        result = prime * result + toHash.hashValue
        return result
    }
}

func ==(lhs: SingleAnnotation, rhs: SingleAnnotation) -> Bool {
    return lhs.coordinate.isEqual(rhs.coordinate)
}

extension CLLocationCoordinate2D {
    func isEqual(rhs:CLLocationCoordinate2D) -> Bool {
        return self.latitude == rhs.latitude && self.longitude == rhs.longitude
    }
}
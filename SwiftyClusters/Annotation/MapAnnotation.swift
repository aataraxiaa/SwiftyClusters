//
//  SingleAnnotation.swift
//  SwiftyClusters
//
//  Created by Peter Smith on 06/10/2015.
//  Copyright © 2015 PeteSmith. All rights reserved.
//

import MapKit

public class MapAnnotation: NSObject, MKAnnotation {
    public var title :String? = ""
    public var subtitle :String? = ""
    public var coordinate:CLLocationCoordinate2D
    
    override public var hashValue: Int {
        get {
            return self.calculateHashValue()
        }
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
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

func ==(lhs: MapAnnotation, rhs: MapAnnotation) -> Bool {
    return lhs.coordinate.isEqual(rhs.coordinate)
}

public extension CLLocationCoordinate2D {
    public func isEqual(rhs:CLLocationCoordinate2D) -> Bool {
        return self.latitude == rhs.latitude && self.longitude == rhs.longitude
    }
}
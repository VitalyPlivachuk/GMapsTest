//
//  CLLocation+RandomCoordinates.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D{
    static func randomCoordinates(between coordinates:(CLLocationCoordinate2D,CLLocationCoordinate2D)) -> CLLocationCoordinate2D{
        let latDelta = coordinates.1.latitude - coordinates.0.latitude
        let longDelta = coordinates.1.longitude - coordinates.0.longitude
        
        let latRandom = latDelta * drand48()
        let longRandom = longDelta * drand48()
        
        return CLLocationCoordinate2D(latitude: coordinates.0.latitude + latRandom,
                                      longitude: coordinates.0.longitude + longRandom)
    }
    
    static var kyivCoord:(CLLocationCoordinate2D,CLLocationCoordinate2D){
        return (CLLocationCoordinate2D(latitude: 50.585881, longitude: 30.246250),
                CLLocationCoordinate2D(latitude: 50.355497, longitude: 30.835475))
    }
}



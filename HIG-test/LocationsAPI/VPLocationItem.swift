//
//  VPLocationItem.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct VPLocationItem: VPLocationItemProtocol {
    let duration: Int
    let color: UIColor?
    let type: VPLocationItemType?
    let location: CLLocationCoordinate2D
}

fileprivate func randomCoordinates(between coordinates:(CLLocationCoordinate2D,CLLocationCoordinate2D)) -> CLLocationCoordinate2D{
    let latDelta = coordinates.1.latitude - coordinates.0.latitude
    let longDelta = coordinates.1.longitude - coordinates.0.longitude
    
    let latRandom = latDelta * drand48()
    let longRandom = longDelta * drand48()
    
    return CLLocationCoordinate2D(latitude: coordinates.0.latitude + latRandom,
                                  longitude: coordinates.0.longitude + longRandom)
}

let kyivCoord:(CLLocationCoordinate2D,CLLocationCoordinate2D)  =
    (CLLocationCoordinate2D(latitude: 50.585881, longitude: 30.246250),
     CLLocationCoordinate2D(latitude: 50.355497, longitude: 30.835475))

extension VPLocationItem: Decodable{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try container.decode(Int.self, forKey: .duration)
        
        let color = try container.decode(String.self, forKey: .color)
        self.color = UIColor(hex: color)
        
        let type = try container.decode(String.self, forKey: .type)
        self.type = VPLocationItemType.init(rawValue:type)
        
        self.location = randomCoordinates(between: kyivCoord)
    }
    
    enum CodingKeys: CodingKey {
        case duration
        case type
        case color
    }
}

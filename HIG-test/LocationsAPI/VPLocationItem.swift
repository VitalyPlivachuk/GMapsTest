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

extension VPLocationItem: Decodable{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try container.decode(Int.self, forKey: .duration)
        
        let color = try container.decode(String.self, forKey: .color)
        self.color = UIColor(hex: color)
        
        let type = try container.decode(String.self, forKey: .type)
        self.type = VPLocationItemType.init(rawValue:type)
        
        let kyiv = CLLocationCoordinate2D.kyivCoord
        self.location = CLLocationCoordinate2D.randomCoordinates(between: kyiv)
    }
    
    enum CodingKeys: CodingKey {
        case duration
        case type
        case color
    }
}

//
//  VPLocationEntity+VPLocationItem.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import CoreLocation

extension VPLocationEntity: VPLocationItemProtocol{
    var duration: Int {
        return Int(self.durationM)
    }
    
    var color: UIColor? {
        guard let hex = self.colorHexM else {return nil}
        return UIColor.init(hex: hex)
    }
    
    var type: VPLocationItemType? {
        guard let typeName = self.typeM else {return nil}
        return VPLocationItemType.init(rawValue: typeName)
    }
    
    var location: CLLocationCoordinate2D {
        return .init(latitude: self.latitudeM, longitude: self.longitudeM)
    }
}

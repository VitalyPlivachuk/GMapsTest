//
//  VPLocationItemProtocol.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

protocol VPLocationItemProtocol{
    var duration:Int {get}
    var color:UIColor? {get}
    var type:VPLocationItemType? {get}
    var location:CLLocationCoordinate2D {get}
}

enum VPLocationItemType:String{
    case hold
    case inhale
    case exhale
}


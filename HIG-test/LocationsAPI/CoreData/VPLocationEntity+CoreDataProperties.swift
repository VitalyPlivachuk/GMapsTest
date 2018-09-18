//
//  VPLocationEntity+CoreDataProperties.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//
//

import Foundation
import CoreData


extension VPLocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VPLocationEntity> {
        return NSFetchRequest<VPLocationEntity>(entityName: "VPLocationEntity")
    }

    @NSManaged public var durationM: Int64
    @NSManaged public var colorHexM: String?
    @NSManaged public var typeM: String?
    @NSManaged public var latitudeM: Double
    @NSManaged public var longitudeM: Double
}

extension VPLocationEntity{
    convenience init(item:VPLocationItemProtocol, context:NSManagedObjectContext) {
        self.init(context: context)
        self.colorHexM = item.color?.toHex
        self.durationM = Int64(item.duration)
        self.latitudeM = item.location.latitude
        self.longitudeM = item.location.longitude
        self.typeM = item.type?.rawValue
    }
}

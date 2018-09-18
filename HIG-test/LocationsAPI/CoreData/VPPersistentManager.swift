//
//  VPPersistentManager.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import CoreData

fileprivate let containerName = "VPLocationModel"
class VPPersistentManager{
    
    let persistentContainer = NSPersistentContainer(name: containerName)
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer.loadPersistentStores { description, error in
            print(description)
            if let error = error {fatalError(error.localizedDescription)}
        }
    }
}

extension VPPersistentManager{
    func getLocations()->[VPLocationEntity]?{
        let context = viewContext
        let fetchRequest: NSFetchRequest<VPLocationEntity> = VPLocationEntity.fetchRequest()
        return try? context.fetch(fetchRequest)
    }
    
    func save(locations: [VPLocationItemProtocol], completion:@escaping (Error?)->()){
        persistentContainer.performBackgroundTask { context in
            do{
                _ = locations.map{VPLocationEntity(item: $0, context: context)}
                try context.save()
                completion(nil)
            } catch let error{
                completion(error)
            }
        }
    }
}

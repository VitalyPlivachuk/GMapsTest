//
//  VPLocationsAPI.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation

class VPLocationsAPI{
    let persistentManager = VPPersistentManager()
    let networkManager = VPNetworkClient()
    
    enum VPLocationsAPIError:Error {
        case emptyLocations
    }
    
    static let shared = VPLocationsAPI()
    
    private init(){}
    
    func getLocations(completion:@escaping ([VPLocationItemProtocol]?, Error?)->()){
        if let locations = persistentManager.getLocations(), !locations.isEmpty{
            completion(locations, nil)
        } else {
            networkManager.getLocations {[weak self] locations, error in
                do{
                    if let error = error {throw error}
                    guard let locations = locations else {throw VPLocationsAPIError.emptyLocations}
                    self?.persistentManager.save(locations: locations, completion: {if $0 != nil {print($0!.localizedDescription)}})
                    completion(locations, nil)
                } catch let error{
                    completion(nil, error)
                }
            }
        }
    }
}

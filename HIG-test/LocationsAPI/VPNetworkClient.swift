//
//  NetworkClient.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation

class VPNetworkClient {
    private let url = URL(string: "https://pastebin.com/raw/DiB5wDpA")!
    
    enum VPNetworkClientError: Error{
        case emptyData
    }
    
    func getLocations(completion:@escaping ([VPLocationItem]?, Error?)->()){
        URLSession.shared.dataTask(with: url) { data, response, error in
            do{
                if let error = error {throw error}
                guard let data = data else {throw VPNetworkClientError.emptyData}
                let decoder = JSONDecoder.init()
                let locationItems = try decoder.decode([VPLocationItem].self, from: data)
                completion(locationItems, nil)
            } catch let error {
                completion(nil,error)
            }
        }.resume()
    }
}

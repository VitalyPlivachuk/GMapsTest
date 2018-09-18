//
//  VPMapModel.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import Foundation
import UIKit

class VPMapModel{
    
    var filteredItems: [VPLocationItemProtocol] = []{
        didSet{
            dataUpdatedCompletion?(filteredItems)
        }
    }
    
    var items: [VPLocationItemProtocol] = []{
        didSet{
            NotificationCenter.default.post(name: .modelUpdated, object: nil)
            filter()
        }
    }
    
    var type: VPLocationItemType? {didSet{filter()}}
    var colors: [UIColor] = [] {didSet{filter()}}
    var minDuration: Int = 0 {didSet{filter()}}
    var maxDuration: Int = 10 {didSet{filter()}}
    
    func loadData(){
        VPLocationsAPI.shared.getLocations {[weak self] locations, error in
            self?.items = locations ?? []
        }
    }
    
    func filter(){
        let items = self.items
        let byType = typeFiltration(locations: items)
        let byColors = colorsFiltration(locations: byType)
        let byDuration = durationFiltration(locations: byColors)
        self.filteredItems = byDuration
    }
    
    func typeFiltration(locations:[VPLocationItemProtocol])->[VPLocationItemProtocol]{
        guard let type = self.type else {return locations}
        return locations.filter{$0.type == type}
    }
    
    func colorsFiltration(locations:[VPLocationItemProtocol])->[VPLocationItemProtocol]{
        guard !colors.isEmpty else {return locations}
        return locations.filter{colors.contains($0.color!)}
    }
    
    func durationFiltration(locations:[VPLocationItemProtocol])->[VPLocationItemProtocol]{
        guard minDuration <= maxDuration else {return locations}
        let durationRange = minDuration...maxDuration
        return locations.filter{durationRange.contains($0.duration)}
    }
    
    private var dataUpdatedCompletion: (([VPLocationItemProtocol])->())?
    
    func set(dataUpdatedCompletion:@escaping ([VPLocationItemProtocol])->()){
        self.dataUpdatedCompletion = dataUpdatedCompletion
    }
}

extension Notification.Name{
    static let modelUpdated = Notification.Name.init("mapModelUpdated")
}


extension VPMapModel: VPFiltersViewControllerDataSource{
    func filtersViewControllerTypes() -> ([String]) {
        let locations = self.items.compactMap{$0.type?.rawValue}
        return Array(Set(locations))
    }
    
    func filtersViewControllerColors() -> ([UIColor]) {
        let colors = self.items.compactMap{$0.color}
        return Array(Set(colors))
    }
}

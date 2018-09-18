//
//  VPMapViewController.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/18/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import GoogleMaps

class VPMapViewController: UIViewController {

    var model:VPMapModel?
    private var lastCameraPosition: GMSCameraPosition?
    
    override func loadView() {
        let mapView = GMSMapView(frame: UIScreen.main.bounds)
        let kyiv = CLLocationCoordinate2D.kyivCoord
        let bounds = GMSCoordinateBounds(coordinate: kyiv.0,
                                         coordinate: kyiv.1)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        mapView.camera = camera
        mapView.delegate = self
        self.view = mapView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model?.set(dataUpdatedCompletion: {[weak self] locations in
            guard let mapView = self?.view as? GMSMapView else {return}
            let markers = locations.map{GMSMarker.init(position: $0.location)}
            mapView.clear()
            markers.forEach{$0.map = mapView}
        })
        model?.loadData()
    }
}

extension CLLocationCoordinate2D{
    func containtsIn(topLeft:CLLocationCoordinate2D,bottomRight:CLLocationCoordinate2D) -> Bool{
        let latitudeRange = bottomRight.latitude ... topLeft.latitude
        let longitudeRange = topLeft.longitude ... bottomRight.longitude
        
        return latitudeRange.contains(self.latitude) && longitudeRange.contains(self.longitude)
    }
    
    func constraintIn(topLeft:CLLocationCoordinate2D,bottomRight:CLLocationCoordinate2D) -> CLLocationCoordinate2D{
        
        let latitude: Double
        let longitude: Double
        
        if self.latitude < bottomRight.latitude {
            latitude = bottomRight.latitude
        } else if self.latitude > topLeft.latitude {
            latitude = topLeft.latitude
        } else {
            latitude = self.latitude
        }
        
        
        if self.longitude < topLeft.longitude{
            longitude = topLeft.longitude
        } else if self.longitude > bottomRight.longitude {
            longitude = bottomRight.longitude
        } else {
            longitude = self.longitude
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
}

extension VPMapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.lastCameraPosition = mapView.camera
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let kyiv = CLLocationCoordinate2D.kyivCoord
        if !position.target.containtsIn(topLeft: kyiv.0,
                                        bottomRight: kyiv.1){
            
            let update = GMSCameraUpdate.setTarget(position.target.constraintIn(topLeft: kyiv.0,
                                                                   bottomRight: kyiv.1))
            
            mapView.moveCamera(update)
            
        }
    }
}


extension VPMapViewController: VPFiltersViewControllerDelegate{
    func filtersViewController(newMinDuration: Int) {
        model?.minDuration = newMinDuration
    }
    
    func filtersViewController(newMaxDuration: Int) {
        model?.maxDuration = newMaxDuration
    }
    
    func filtersViewController(newColors: [UIColor]) {
        model?.colors = newColors
    }
    
    func filtersViewController(newType: String?) {
        if let newType = newType, let type = VPLocationItemType.init(rawValue: newType) {
            model?.type = type
        } else {
            model?.type = nil
        }
    }
}

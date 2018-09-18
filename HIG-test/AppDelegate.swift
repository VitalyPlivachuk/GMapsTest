//
//  AppDelegate.swift
//  HIG-test
//
//  Created by Vitaly Plivachuk on 9/17/18.
//  Copyright © 2018 Vitaly Plivachuk. All rights reserved.
//

import UIKit
import GoogleMaps
import Pulley

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCHCIIU2CRTNdorjf8VsGZi7syQL5mzIDM")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let mapVC = VPMapViewController()
        mapVC.model = VPMapModel()
        
        let filterVC = VPFiltersViewController.init(nibName: "VPFiltersViewController", bundle: nil)
        filterVC.delegate = mapVC
        filterVC.dataSource = mapVC.model
        
        let vc = PulleyViewController(contentViewController: mapVC, drawerViewController: filterVC)
        vc.delegate = filterVC
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
}


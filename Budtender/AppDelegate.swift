//
//  AppDelegate.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/13/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {} else {
            /// Create the storyboard programmatically
            window = UIWindow(frame: UIScreen.main.bounds)
            /// Create the navigation controller and assign the root view controller to the selection screen
            let navigationController = UINavigationController(rootViewController: SelectionViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            
        }
        return true
        
    }


}


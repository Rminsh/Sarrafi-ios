//
//  AppDelegate.swift
//  Sarrafi
//
//  Created by armin on 1/23/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Shabnam-FD", size: 15)!], for: UIControl.State.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Shabnam-FD", size: 10)!], for: UIControl.State.normal)
        
        return true
    }

}


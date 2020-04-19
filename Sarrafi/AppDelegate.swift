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
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        return true
    }

}


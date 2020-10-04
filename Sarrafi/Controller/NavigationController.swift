//
//  NavigationController.swift
//  Sarrafi
//
//  Created by armin on 3/26/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
		UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.shabnam(ofSize: 15)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.shabnam(ofSize: 15)], for: .highlighted)
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "لغو"
		
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.shabnam(ofSize: 10)], for: .normal)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "جست و جو",
			attributes: [
				.font: UIFont.shabnam(ofSize: 15),
				.paragraphStyle: titleParagraphStyle
			]
		)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
			.font: UIFont.shabnam(ofSize: 15)
		]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "BackgroundColor")
            appearance.titleTextAttributes = [.font: UIFont.shabnam(ofSize: 18)]
            appearance.largeTitleTextAttributes = [.font: UIFont.shabnam(ofSize: 32, weight: .medium)]
            
            // NAV BUTTON STYLING
            let button = UIBarButtonItemAppearance(style: .plain)
            button.normal.titleTextAttributes = [.font: UIFont.shabnam(ofSize: 18)]
            appearance.buttonAppearance = button
            
            //Remove NavigationBar Border
            appearance.shadowColor = .clear
            
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
            self.navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
            
        } else {
            self.navigationBar.titleTextAttributes = [.font: UIFont.shabnam(ofSize: 18)]
			self.navigationBar.largeTitleTextAttributes = [.font: UIFont.shabnam(ofSize: 32, weight: .medium)]
            
            //Remove NavigationBar Border
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }

}

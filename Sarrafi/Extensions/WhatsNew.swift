//
//  WhatsNew.swift
//  Sarrafi
//
//  Created by armin on 4/25/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit
import WhatsNewKit

extension MainController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: "چیزهای جدید در صرافی",
            // The features you want to showcase
            items: [
                WhatsNew.Item(
                    title: "جست و جو",
                    subtitle: "اضافه شدن قابلیت جست و جو در لیست",
                    image: #imageLiteral(resourceName: "ic_new_search")
                ),
                WhatsNew.Item(
                    title: "رابط کاربری جدید",
                    subtitle: "بهبود و ساده‌سازی رابط کاربری در برنامه",
                    image: #imageLiteral(resourceName: "ic_new_interface")
                )
            ]
        )
        
        // Initialize WhatsNewVersionStore
        let versionStore: WhatsNewVersionStore = KeyValueWhatsNewVersionStore()
        
        // Initialize default Configuration
        var configuration = WhatsNewViewController.Configuration()

        // Customize Configuration to your needs
        configuration.backgroundColor = UIColor(named: "BackgroundColor")!
        configuration.itemsView.subtitleFont = UIFont(name: "Shabnam-FD", size: 15)!
        configuration.itemsView.titleFont = UIFont(name: "Shabnam-Medium-FD", size: 17)!
        configuration.titleView.titleFont = UIFont(name: "Shabnam-Bold-FD", size: 32)!
        configuration.completionButton.titleFont = UIFont(name: "Shabnam-FD", size: 18)!
        configuration.completionButton.title = "ادامه"

        // Initialize WhatsNewViewController with custom configuration
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration,
            versionStore: versionStore
        )
        
        // Verify WhatsNewViewController is available
        guard let viewController = whatsNewViewController else {
            // The user has already seen the WhatsNew-Screen for the current Version of your app
            return
        }

        // Present WhatsNewViewController
        self.present(viewController, animated: true)
    }
}

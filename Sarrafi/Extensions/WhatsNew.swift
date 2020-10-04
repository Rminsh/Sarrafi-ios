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
		configuration.itemsView.subtitleFont = .shabnam(ofSize: 15)
		configuration.itemsView.titleFont = .shabnam(ofSize: 17, weight: .medium)
		configuration.titleView.titleFont = .shabnam(ofSize: 32, weight: .bold)
		configuration.completionButton.titleFont = .shabnam(ofSize: 18)
        configuration.completionButton.title = "ادامه"

        // Initialize WhatsNewViewController with custom configuration
        let whatsNewViewController = WhatsNewViewController(
            whatsNew		: whatsNew,
            configuration	: configuration,
            versionStore	: versionStore
        )
        
        // Verify WhatsNewViewController is available
        guard let viewController = whatsNewViewController else {
            // The user has already seen the WhatsNew-Screen for the current Version of your app
            return
        }

        // Present WhatsNewViewController
        present(viewController, animated: true)
    }
	
}

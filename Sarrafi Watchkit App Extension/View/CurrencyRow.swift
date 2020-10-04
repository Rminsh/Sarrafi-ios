//
//  CurrencyRow.swift
//  Sarrafi Watchkit App Extension
//
//  Created by armin on 5/8/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import WatchKit

class CurrencyRow: NSObject {
    @IBOutlet weak var background: WKInterfaceGroup!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var percentLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    func updateUI(items : CurrencyModel) {
        titleLabel.setText(items.title)
        priceLabel.setText("\(items.currentPrice) \(items.toCurrency)")
        timeLabel.setText(items.updateTime)
        
        switch items.status {
        case "high":
            background.setBackgroundImage(#imageLiteral(resourceName: "ic_gradient_high"))
            percentLabel.setText("+\(items.percentChange)٪")
        case "low":
            background.setBackgroundImage(#imageLiteral(resourceName: "ic_gradient_low"))
            percentLabel.setText("-\(items.percentChange)٪")
        default:
            background.setBackgroundImage(#imageLiteral(resourceName: "ic_gradient_normal"))
            percentLabel.setText("بدون تغییر")
        }
    }
}

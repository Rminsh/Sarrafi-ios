//
//  DetailController.swift
//  Sarrafi Watchkit App Extension
//
//  Created by armin on 5/9/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import WatchKit
import Foundation


class DetailController: WKInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var percentChangeLabel: WKInterfaceLabel!
    @IBOutlet weak var priceChangeLabel: WKInterfaceLabel!
    @IBOutlet weak var highPriceLabel: WKInterfaceLabel!
    @IBOutlet weak var lowPriceLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let item = context as! CurrencyModel
        updateUI(items: item)
    }

    override func willActivate() {
        // This method is ca lled when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func updateUI (items : CurrencyModel) {
        titleLabel.setText(items.title)
        priceLabel.setText("\(items.currentPrice) \(items.toCurrency)")
        timeLabel.setText(items.updateTime)
        
        timeLabel.setText("آخرین به‌روزرسانی \(items.updateTime)")
        highPriceLabel.setText("\(items.priceUp) \(items.toCurrency)")
        lowPriceLabel.setText("\(items.priceDown) \(items.toCurrency)")
        priceChangeLabel.setText("\(items.priceChange) \(items.toCurrency)")
        
        switch items.status {
        case "high":
            percentChangeLabel.setTextColor(#colorLiteral(red: 0.05882352941, green: 0.8, blue: 0.5647058824, alpha: 1))
            priceChangeLabel.setTextColor(#colorLiteral(red: 0.05882352941, green: 0.8, blue: 0.5647058824, alpha: 1))
            percentChangeLabel.setText("(+\(items.percentChange)٪)")
        case "low":
            percentChangeLabel.setTextColor(#colorLiteral(red: 0.8745098039, green: 0.337254902, blue: 0.6588235294, alpha: 1))
            priceChangeLabel.setTextColor(#colorLiteral(red: 0.8745098039, green: 0.337254902, blue: 0.6588235294, alpha: 1))
            percentChangeLabel.setText("-\(items.percentChange)٪")
            
        default:
            percentChangeLabel.setText("بدون تغییر")
        }
    }
}

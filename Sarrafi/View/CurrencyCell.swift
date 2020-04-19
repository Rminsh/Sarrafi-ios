//
//  CurrencyCell.swift
//  Sarrafi
//
//  Created by armin on 1/23/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func updateUI (items : CurrencyModel) {
        titleLabel.text = items.title
        priceLabel.text = "\(items.currentPrice) \(items.toCurrency)"
        
        timeLabel.text = items.updateTime
        
        switch items.status {
        case "high":
            cardView.startColor = #colorLiteral(red: 0.2274509804, green: 0.631372549, blue: 0.4941176471, alpha: 1)
            cardView.endColor = #colorLiteral(red: 0, green: 0.3254901961, blue: 0.4941176471, alpha: 1)
            statusImage.image = #imageLiteral(resourceName: "ic_arrow_up")
            percentLabel.text = "\(items.percentChange)٪"
        case "low":
            cardView.startColor = #colorLiteral(red: 0.9294117647, green: 0.1176470588, blue: 0.4745098039, alpha: 1)
            cardView.endColor = #colorLiteral(red: 0.4, green: 0.1764705882, blue: 0.5490196078, alpha: 1)
            statusImage.image = #imageLiteral(resourceName: "ic_arrow_down")
            percentLabel.text = "\(items.percentChange)٪"
        default:
            cardView.startColor = #colorLiteral(red: 0.1607843137, green: 0.6705882353, blue: 0.8862745098, alpha: 1)
            cardView.endColor = #colorLiteral(red: 0.3098039216, green: 0, blue: 0.737254902, alpha: 1)
            statusImage.image = nil
            percentLabel.text = "بدون تغییر"
        }
    }
}

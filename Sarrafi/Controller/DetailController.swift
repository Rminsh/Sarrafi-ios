//
//  DetailController.swift
//  Sarrafi
//
//  Created by armin on 4/20/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit
import Alamofire
import UICircularProgressRing

class DetailController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var chartSegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var percentChangeProgress: UICircularProgressRing!
    @IBOutlet weak var priceHighLabel: UILabel!
    @IBOutlet weak var priceLowLabel: UILabel!
    
    var currency: CurrencyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        sendGetTableRequest()
    }
    
    func setupInterface() {
        print("✅OBJECT \(currency.object)")
        self.title = currency.title
        chartSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Shabnam-FD", size: 12)!], for: UIControl.State.normal)
        
        priceLabel.text = "\(currency.currentPrice) \(currency.toCurrency)"
        updateLabel.text = "آخرین به‌روزرسانی \(currency.updateTime)"
        priceHighLabel.text = "\(currency.priceUp) \(currency.toCurrency)"
        priceLowLabel.text = "\(currency.priceDown) \(currency.toCurrency)"
        
        percentChangeProgress.fullCircle = true
        percentChangeProgress.isClockwise = true
        percentChangeProgress.startAngle = -90
        percentChangeProgress.endAngle = -90
        percentChangeProgress.innerRingWidth = 5
        percentChangeProgress.outerRingWidth = 3
        percentChangeProgress.outerRingColor = UIColor(named: "ThirdBackgroundColor")!
        percentChangeProgress.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = UICircularProgressRingFormatter(showFloatingPoint: true)
        percentChangeProgress.valueFormatter = formatter
        percentChangeProgress.value = CGFloat((currency.percentChange as NSString).floatValue)
        if #available(iOS 13.0, *) {
            percentChangeProgress.fontColor = UIColor.label
        } else {
            percentChangeProgress.fontColor = UIColor.black
        }
        
        switch currency.status {
        case "high":
            percentChangeProgress.innerRingColor = UIColor(named: "PriceUp")!
            priceChangeLabel.textColor = UIColor(named: "PriceUp")!
            priceChangeLabel.text = "افزایش \(currency.priceChange) \(currency.toCurrency)"
        case "low":
            percentChangeProgress.innerRingColor = UIColor(named: "PriceDown")!
            priceChangeLabel.textColor = UIColor(named: "PriceDown")!
            priceChangeLabel.text = "کاهش \(currency.priceChange) \(currency.toCurrency)"
        default:
            percentChangeProgress.innerRingColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            priceChangeLabel.text = "بدون تغییر"
        }
    }
    
    func sendGetTableRequest() {
        /**
         Get table
         get https://www.tgju.org/
         */

        // Add URL parameters
        let urlParams = [
            "act":"chart-api",
            "noview":"null",
            "client":"app",
            "appversion":"3",
            "name": currency.object,
        ]

        // Fetch Request
        AF.request("https://www.tgju.org/", method: .get, parameters: urlParams, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response.data)
                    break
                case .failure:
                    print("Error")
                    break
                }
        }
    }

    
}

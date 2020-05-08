//
//  CurrencyController.swift
//  Sarrafi Watchkit App Extension
//
//  Created by armin on 5/8/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import WatchKit
import Alamofire

class CurrencyController: WKInterfaceController {

    @IBOutlet weak var currencyTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        currencyTable.setNumberOfRows(20, withRowType: "currency_row")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

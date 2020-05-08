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
    var currencyStats = [CurrencyModel]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        sendCurrencyRequest()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "rowDetail" {
            return currencyStats[rowIndex]
        }
        return nil
    }
    
    // MARK: - Getting Data
    func sendCurrencyRequest() {
        
        do {
            try CurrencyService.shared.getList { (response, error) in
                
                if let error = error {
                    print(error)
                } else {
                    if let result = response?.currencyStats {
                        self.currencyStats = result
                        self.currencyTable.setNumberOfRows(self.currencyStats.count, withRowType: "currency_row")
                        
                        for (index, currencyModel) in self.currencyStats.enumerated() {
                            guard let row = self.currencyTable.rowController(at: index) as? CurrencyRow else { continue }
                            row.updateUI(items: currencyModel)
                        }
                    }
                }
            }
        } catch {

        }
    }
}

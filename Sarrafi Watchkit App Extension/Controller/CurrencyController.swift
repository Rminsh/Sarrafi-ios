//
//  CurrencyController.swift
//  Sarrafi Watchkit App Extension
//
//  Created by armin on 5/8/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import WatchKit

class CurrencyController: WKInterfaceController {

    @IBOutlet weak var currencyTable: WKInterfaceTable!
    @IBOutlet weak var emptyStateImage: WKInterfaceImage!
    @IBOutlet weak var emptyStateLabel: WKInterfaceLabel!
    @IBOutlet weak var emptyStateButton: WKInterfaceButton!
    
    var currencyStats = [CurrencyModel]()
    var indicator: EMTLoadingIndicator?
    
    // MARK: - View life cycle
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
            showLoading()
            
            try CurrencyService.shared.getList { (response, error) in
                
                if let error = error {
                    switch error {
                    case NetworkingError.badNetworkingRequest:
                        self.showError(error: "خطا در ارسال درخواست", asEmptyState: self.currencyStats.isEmpty)
                    case NetworkingError.errorParse:
                        self.showError(error: "خطا در بارگزاری اطلاعات", asEmptyState: self.currencyStats.isEmpty)
                    default:
                        self.showError(error: "خطا", asEmptyState: self.currencyStats.isEmpty)
                    }
                } else {
                    if let result = response?.currencyStats {
                        self.currencyStats = result
                        self.currencyTable.setNumberOfRows(self.currencyStats.count, withRowType: "currency_row")
                        
                        for (index, currencyModel) in self.currencyStats.enumerated() {
                            guard let row = self.currencyTable.rowController(at: index) as? CurrencyRow else { continue }
                            row.updateUI(items: currencyModel)
                        }
                        
                        self.showItems()
                    }
                }
            }
        } catch {
             self.showError(error: "خطا در ارسال درخواست", asEmptyState: self.currencyStats.isEmpty)
        }
    }
    
    // MARK: - UI Show Loading
    func showLoading() {
        indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: emptyStateImage!,
        width: 40, height: 40, style: .dot)
        indicator?.prepareImagesForWait()
        indicator?.showWait()
        
        currencyTable.setHidden(true)
        emptyStateLabel.setHidden(true)
        emptyStateButton.setHidden(true)
    }
    
    // MARK: - UI Show Items
    func showItems() {
        indicator?.hide()
        currencyTable.setHidden(false)
    }
    
    // MARK: - UI Show Error
    func showError(error: String, asEmptyState: Bool) {
        if asEmptyState {
            emptyStateImage.setImage(#imageLiteral(resourceName: "ic_no_network"))
            emptyStateLabel.setText(error)
            emptyStateLabel.setHidden(false)
            emptyStateButton.setHidden(false)
        } else {
            let ok = WKAlertAction.init(title: "باشه", style:.cancel){}
            presentAlert(withTitle: "خطا", message: error, preferredStyle:.actionSheet, actions: [ok])
        }
    }
    
    // MARK: - Action Retry Button
    @IBAction func tryAgainPressed() {
        sendCurrencyRequest()
    }
}

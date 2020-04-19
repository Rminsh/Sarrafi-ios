//
//  MainController.swift
//  Sarrafi
//
//  Created by armin on 4/19/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit
import Alamofire

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var currencyCollection: UICollectionView!
    
    @IBOutlet weak var emptyStateStackView: UIStackView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currencyStats = [CurrencyModel]()
    private let spacing:CGFloat = 5
    
    // MARK: - Collection view count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyStats.count
    }
    
    // MARK: - Collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currency_cell", for: indexPath) as? CurrencyCell {
            let _items = currencyStats [indexPath.row]
            cell.updateUI(items: _items)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minimumWidthSize = CGFloat(157)
        let maxWidth = collectionView.bounds.size.width
        let maxCellPerRow = CGFloat(Int(maxWidth / minimumWidthSize))
        let width = (maxWidth / maxCellPerRow)
        return CGSize(width: CGFloat(width), height: CGFloat(135))
    }
    
    // MARK: - Collection view on click
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //  widgetPressed(item: items [indexPath.row], parentVC: self)
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCurrencyRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyCollection.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Getting Data
    func sendCurrencyRequest() {
        /**
         Currency
         get http://call.tgju.org/ajax.json
         */

        // Fetch Request
        AF.request("https://call.tgju.org/ajax.json", method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.currencyStats = [CurrencyModel]()
                self.currencyCollection.reloadData()
                
                self.activityIndicator.isHidden = true
                self.emptyStateStackView.isHidden = true
                
                switch response.result {
                case .success:
                    do {
                        let decoder = try JSONDecoder().decode(CurrencyStruct.self, from: response.data!)
                        self.addObj(currencyObject: decoder.current.price_dollar_rl, title: "دلار آمریکا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_dollar_soleymani, title: "دلار سلیمانیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_eur, title: "یورو", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_cad, title: "دلار کانادا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_gbp, title: "پوند انگلیس", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_aed, title: "درهم امارات", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_try, title: "لیر ترکیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_cny, title: "یوان چین", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_jpy, title: "ین ژاپن", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_afn, title: "افغانی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_iqd, title: "دینار عراق", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_myr, title: "رینگیت مالزی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_rub, title: "روبل روسیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_inr, title: "روپیه هند", toCurrency: currency.rial)
                        
                        self.addObj(currencyObject: decoder.current.sekee, title: "سکه امامی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.sekeb, title: "سکه بهار آزادی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.nim, title: "نیم سکه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.rob, title: "ربع سکه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.geram24, title: "طلای ۲۴ عیار", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.geram18, title: "طلای ۱۸ عیار", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.mesghal, title: "مثقال طلا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.gerami, title: "سکه گرمی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.ons, title: "انس طلا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.silver, title: "انس نقره", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.gold_mini_size, title: "طلای دست دوم", toCurrency: currency.rial)
                        
                        self.addObj(currencyObject: decoder.current.bitcoin, title: "بیت کوین / Bitcoin", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.ethereum, title: "اتریوم / Ethereum", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.ripple, title: "ریپل / Ripple", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.dash, title: "دش / Dash", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.litecoin, title: "لایت کوین/Litecoin", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.stellar, title: "استلار / Stellar", toCurrency: currency.dollar)
                        self.currencyCollection.reloadData()
                        
                    } catch {
                        print(error)
                        self.emptyStateStackView.isHidden = false
                        self.emptyStateLabel.text = "خطا در بارگزاری اطلاعات"
                        self.emptyStateButton.isHidden = false
                    }
                case .failure:
                    self.emptyStateStackView.isHidden = false
                    self.emptyStateLabel.text = "خطا در ارسال درخواست"
                    self.emptyStateButton.isHidden = false
                }
            }
    }
    
    // MARK: - Adding Objects
    func addObj(currencyObject: CurrencyDetail, title: String, toCurrency: String) {
        currencyStats.append(CurrencyModel(
            title: title,
            currentPrice: currencyObject.p,
            toCurrency: toCurrency,
            status: currencyObject.dt,
            priceUp: currencyObject.h,
            priceDown: currencyObject.l,
            percentChange: String(currencyObject.dp),
            priceChange: currencyObject.d,
            updateTime: currencyObject.t))
    }

}

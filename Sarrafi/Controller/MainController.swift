//
//  MainController.swift
//  Sarrafi
//
//  Created by armin on 4/19/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import MBProgressHUD

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {

    @IBOutlet weak var currencyCollection: UICollectionView!
    
    @IBOutlet weak var emptyStateStackView: UIStackView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateButton: UIButton!
    @IBOutlet weak var emptyStateLottie: AnimationView!
    
    var refresher: UIRefreshControl!
    var currencyStats = [CurrencyModel]()
    var filteredStats: [CurrencyModel] = []
    var searching = false
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Collection view count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searching ? filteredStats.count : currencyStats.count
    }
    
    // MARK: - Collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currency_cell", for: indexPath) as? CurrencyCell {
            let _items = searching ? filteredStats[indexPath.row] : currencyStats[indexPath.row]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "detail_vc") as! DetailController
        vc.modalPresentationStyle = .fullScreen
        vc.currency = searching ? filteredStats[indexPath.row] : currencyStats[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.semanticContentAttribute = .forceRightToLeft
        navigationItem.searchController = searchController
         
        emptyStateLottie.loopMode = .loop
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "به روزرسانی اطلاعات" , attributes: [.font: UIFont(name: "Shabnam-FD", size: 12)!])
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        currencyCollection.refreshControl = refresher
        
        showLoading()
        
        if (Reachability.isConnectedToNetwork()) {
            sendCurrencyRequest()
        } else {
            showError(error: "به اینترنت متصل نیستید")
        }
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

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData

        var req = URLRequest(url: URL(string: "https://call.tgju.org/ajax.json")!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // Fetch Request
        AF.request(req)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.currencyStats = [CurrencyModel]()
                self.currencyCollection.reloadData()
                
                self.emptyStateLottie.stop()
                self.refresher.endRefreshing()
                self.emptyStateStackView.isHidden = true
                
                switch response.result {
                case .success:
                    do {
                        let decoder = try JSONDecoder().decode(CurrencyStruct.self, from: response.data!)
                        self.addObj(currencyObject: decoder.current.price_dollar_rl, currencyName: Current.CodingKeys.price_dollar_rl.rawValue, title: "دلار آمریکا", toCurrency:currency.rial)
                        self.addObj(currencyObject: decoder.current.price_dollar_soleymani, currencyName: Current.CodingKeys.price_dollar_soleymani.rawValue, title: "دلار سلیمانیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_eur, currencyName: Current.CodingKeys.price_eur.rawValue, title: "یورو", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_cad, currencyName: Current.CodingKeys.price_cad.rawValue, title: "دلار کانادا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_gbp, currencyName: Current.CodingKeys.price_gbp.rawValue, title: "پوند انگلیس", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_aed, currencyName: Current.CodingKeys.price_aed.rawValue, title: "درهم امارات", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_try, currencyName: Current.CodingKeys.price_try.rawValue, title: "لیر ترکیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_cny, currencyName: Current.CodingKeys.price_cny.rawValue, title: "یوان چین", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_jpy, currencyName: Current.CodingKeys.price_jpy.rawValue, title: "ین ژاپن", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_afn, currencyName: Current.CodingKeys.price_afn.rawValue, title: "افغانی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_iqd, currencyName: Current.CodingKeys.price_iqd.rawValue, title: "دینار عراق", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_myr, currencyName: Current.CodingKeys.price_myr.rawValue, title: "رینگیت مالزی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_rub, currencyName: Current.CodingKeys.price_rub.rawValue, title: "روبل روسیه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.price_inr, currencyName: Current.CodingKeys.price_inr.rawValue, title: "روپیه هند", toCurrency: currency.rial)
                        
                        self.addObj(currencyObject: decoder.current.sekee, currencyName: Current.CodingKeys.sekee.rawValue, title: "سکه امامی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.sekeb, currencyName: Current.CodingKeys.sekeb.rawValue, title: "سکه بهار آزادی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.nim, currencyName: Current.CodingKeys.nim.rawValue, title: "نیم سکه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.rob, currencyName: Current.CodingKeys.rob.rawValue, title: "ربع سکه", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.geram24, currencyName: Current.CodingKeys.geram24.rawValue, title: "طلای ۲۴ عیار", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.geram18, currencyName: Current.CodingKeys.geram18.rawValue, title: "طلای ۱۸ عیار", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.mesghal, currencyName: Current.CodingKeys.mesghal.rawValue, title: "مثقال طلا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.gerami, currencyName: Current.CodingKeys.gerami.rawValue, title: "سکه گرمی", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.ons, currencyName: Current.CodingKeys.ons.rawValue, title: "انس طلا", toCurrency: currency.rial)
                        self.addObj(currencyObject: decoder.current.silver, currencyName: Current.CodingKeys.silver.rawValue, title: "انس نقره", toCurrency: currency.rial)
                        
                        self.addObj(currencyObject: decoder.current.bitcoin, currencyName: Current.CodingKeys.bitcoin.rawValue, title: "بیت کوین / Bitcoin", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.ethereum, currencyName: Current.CodingKeys.ethereum.rawValue, title: "اتریوم / Ethereum", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.ripple, currencyName: Current.CodingKeys.ripple.rawValue, title: "ریپل / Ripple", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.dash, currencyName: Current.CodingKeys.dash.rawValue, title: "دش / Dash", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.litecoin, currencyName: Current.CodingKeys.litecoin.rawValue, title: "لایت کوین/Litecoin", toCurrency: currency.dollar)
                        self.addObj(currencyObject: decoder.current.stellar, currencyName: Current.CodingKeys.stellar.rawValue, title: "استلار / Stellar", toCurrency: currency.dollar)
                        self.currencyCollection.reloadData()
                        
                    } catch {
                        print(error)
                        if (self.currencyStats.isEmpty) {
                            self.showError(error: "خطا در بارگزاری اطلاعات")
                        } else {
                            self.failedHUD(error: "خطا در بارگزاری اطلاعات")
                        }
                        
                    }
                case .failure:
                    if (self.currencyStats.isEmpty) {
                        self.showError(error: "خطا در ارسال درخواست")
                    } else {
                        self.failedHUD(error: "خطا در ارسال درخواست")
                    }
                }
            }
    }
    
    // MARK: - Adding Objects
    func addObj(currencyObject: CurrencyDetail, currencyName: String, title: String, toCurrency: String) {
        currencyStats.append(CurrencyModel(
            object: currencyName,
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
    
    func showLoading() {
        emptyStateStackView.isHidden = false
        emptyStateLabel.isHidden = true
        emptyStateButton.isHidden = true
        emptyStateLottie.animation = Animation.named("loading_animation")
        emptyStateLottie.play()
    }
    
    func showError(error: String) {
        emptyStateStackView.isHidden = false
        emptyStateButton.isHidden = false
        emptyStateLabel.isHidden = false
        emptyStateLabel.text = error
        emptyStateLottie.animation = Animation.named("no_internet_connection")
        emptyStateLottie.play()
    }
    
    func failedHUD(error : String) {
        let hudInternet = MBProgressHUD.showAdded(to: self.view, animated: true)
        hudInternet.mode = MBProgressHUDMode.customView
        hudInternet.customView = UIImageView(image: #imageLiteral(resourceName: "ic_error"))
        hudInternet.label.attributedText = NSAttributedString(string: error , attributes: [.font: UIFont(name: "Shabnam-FD", size: 14)!])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            hudInternet.hide(animated: true)
        })
    }

    @IBAction func tryAgainPressed(_ sender: Any) {
        showLoading()
        if (Reachability.isConnectedToNetwork()) {
            sendCurrencyRequest()
        } else {
            showError(error: "به اینترنت متصل نیستید")
        }
    }
    
    @objc func refresh() {
        if Reachability.isConnectedToNetwork() {
            sendCurrencyRequest()
        } else {
            self.failedHUD(error: "به اینترنت متصل نیستید")
            refresher.endRefreshing()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredStats = currencyStats.filter({$0.title.prefix(searchController.searchBar.text!.count) == searchController.searchBar.text!})
        searching = true
        currencyCollection.reloadData()
    }
}

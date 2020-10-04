//
//  MainController.swift
//  Sarrafi
//
//  Created by armin on 4/19/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import UIKit
import Lottie
import MBProgressHUD

class MainController: UIViewController {

    @IBOutlet weak var currencyCollection	: UICollectionView!
    @IBOutlet weak var emptyStateStackView	: UIStackView!
    @IBOutlet weak var emptyStateLabel		: UILabel!
    @IBOutlet weak var emptyStateButton		: UIButton!
    @IBOutlet weak var emptyStateLottie		: AnimationView!
    
    var refresher: UIRefreshControl!
    var currencyStats = [CurrencyModel]()
    var filteredStats: [CurrencyModel] = []
    var searching = false
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.semanticContentAttribute = .forceRightToLeft
        navigationItem.searchController = searchController
         
        emptyStateLottie.loopMode = .loop
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(
			string: "به روزرسانی اطلاعات" ,
			attributes: [
				.font: UIFont.shabnam(ofSize: 12)
			]
		)
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        currencyCollection.refreshControl = refresher
        
        showLoading()
        
        if (Reachability.isConnectedToNetwork()) {
            sendCurrencyRequest()
        } else {
            showError(error: "به اینترنت متصل نیستید", asEmptyState: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyCollection.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Getting Data
    func sendCurrencyRequest() {
        
		CurrencyService.shared.getList { (result) in
			
			switch result {
			case .failure(let error):
				switch error {
				case .connectionIssue:
					self.showError(error: "خطا در ارسال درخواست", asEmptyState: self.currencyStats.isEmpty)
				case .parsingError:
					self.showError(error: "خطا در بارگزاری اطلاعات", asEmptyState: self.currencyStats.isEmpty)
				}
			case .success(let response):
				let stats = response.currencyStats
				self.currencyStats = stats
				self.currencyCollection.reloadData()
				self.emptyStateLottie.stop()
				self.refresher.endRefreshing()
				self.emptyStateStackView.isHidden = true
			}
		}
    }
    
    // MARK: - UI Show Loading
    func showLoading() {
        emptyStateStackView.isHidden = false
        emptyStateLabel.isHidden = true
        emptyStateButton.isHidden = true
        emptyStateLottie.animation = Animation.named("loading_animation")
        emptyStateLottie.play()
    }
    
    // MARK: - UI Show Error
    func showError(error: String, asEmptyState: Bool) {
        if asEmptyState {
            emptyStateStackView.isHidden = false
            emptyStateButton.isHidden = false
            emptyStateLabel.isHidden = false
            emptyStateLabel.text = error
            emptyStateLottie.animation = Animation.named("no_internet_connection")
            emptyStateLottie.play()
        } else {
            let hudInternet = MBProgressHUD.showAdded(to: self.view, animated: true)
            hudInternet.mode = MBProgressHUDMode.customView
            hudInternet.customView = UIImageView(image: #imageLiteral(resourceName: "ic_error"))
            hudInternet.label.attributedText = NSAttributedString(
				string: error,
				attributes: [
					.font: UIFont.shabnam(ofSize: 14)
				]
			)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                hudInternet.hide(animated: true)
            })
        }
    }

    // MARK: - Action Retry Button
    @IBAction func tryAgainPressed(_ sender: Any) {
        showLoading()
        if (Reachability.isConnectedToNetwork()) {
            sendCurrencyRequest()
        } else {
            showError(error: "به اینترنت متصل نیستید", asEmptyState: true)
        }
    }
    
    // MARK: - Refresh List
    @objc func refresh() {
        if Reachability.isConnectedToNetwork() {
            sendCurrencyRequest()
        } else {
            self.showError(error: "به اینترنت متصل نیستید", asEmptyState: false)
            refresher.endRefreshing()
        }
    }
    
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
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
	
	// MARK: - Collection view cell size
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
	
}

extension MainController: UISearchResultsUpdating {
	
	// MARK: - Search result update
	func updateSearchResults(for searchController: UISearchController) {
		filteredStats = currencyStats.filter {
			$0.title.prefix(searchController.searchBar.text!.count) == searchController.searchBar.text!
		}
		searching = true
		currencyCollection.reloadData()
	}
	
}


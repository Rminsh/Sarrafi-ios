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
import Charts

class DetailController: UIViewController {

    @IBOutlet weak var priceLabel				: UILabel!
    @IBOutlet weak var updateLabel				: UILabel!
    @IBOutlet weak var chartSegmentedControl	: UISegmentedControl!
    @IBOutlet weak var priceChangeLabel			: UILabel!
    @IBOutlet weak var percentChangeProgress	: UICircularProgressRing!
    @IBOutlet weak var priceHighLabel			: UILabel!
    @IBOutlet weak var priceLowLabel			: UILabel!
    @IBOutlet weak var chartActivityIndicator	: UIActivityIndicatorView!
    @IBOutlet weak var chart					: LineChartView!
    
    var currency: CurrencyModel!
    
	var chartsObject: Charts? = nil
    
    @IBAction func filterIndexChanged(_ sender: Any) {
        loadFilters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        sendGetTableRequest()
    }
    
    func setupInterface() {
        self.title = currency.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "ic_share"),
			style: .done,
			target: self,
			action: #selector(shareItem)
		)
		
		chartSegmentedControl.setTitleTextAttributes([.font: UIFont.shabnam(ofSize: 12)], for: .normal)
        
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
        percentChangeProgress.value = CGFloat((currency.percentChange as NSString).doubleValue)
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
        
        chart.extraRightOffset = 40
        chart.chartDescription?.enabled = false
        chart.legend.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.noDataText = "هیچ دیتایی موجود نیست"
		chart.noDataFont = .shabnam(ofSize: 14)
        
    }
    
    func sendGetTableRequest() {
		CurrencyService.shared.getChart(for: currency) { (result) in
			switch result {
			case .success(let charts):
				self.chartsObject = charts
				self.loadFilters()
			case .failure(let error):
				print(error)
				self.showChart()
			}
		}
    }
    
    func loadFilters() {
		guard let chartsObject = chartsObject else { return }
        switch chartSegmentedControl.selectedSegmentIndex {
        case 0:
            // Today chart
			setDataChart(with: chartsObject.day)
        case 1:
            // Monthly Chart
			setDataChart(with: chartsObject.month)
        case 2:
            // 3 Months Chart
			setDataChart(with: chartsObject.threeMonths)
        case 3:
            // 6 Months Chart
			setDataChart(with: chartsObject.sixMonths)
        case 4:
            // Chart Summery
			setDataChart(with: chartsObject.summary)
            
        default:
            break
        }
    }
    
	func setDataChart(with chartItem: ChartItem) {
        // Set xAxis
        DispatchQueue.main.async {
            let xAxis = self.chart.xAxis
            xAxis.avoidFirstLastClippingEnabled = false
			xAxis.valueFormatter = IndexAxisValueFormatter(values: chartItem.dates)
            let marker = BalloonMarker(
				date		: chartItem.dates,
                priceType	: self.currency.toCurrency,
                color		: UIColor(named: "Accent")!,
				font		: .shabnam(ofSize: 12),
                textColor	: .white,
                insets		: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0)
			)
			marker.minimumSize = CGSize(width: 75.0, height: 35.0)
            self.chart.marker = marker
        }
        
        // Set yAxis
        DispatchQueue.main.async {
            var dataEntry = [ChartDataEntry]()
			let circleStatus = chartItem.prices.count <= 90
            
			for item in 0..<chartItem.prices.count {
				dataEntry.append(ChartDataEntry(x: Double(item), y: chartItem.prices[item]))
            }
            
            let lineDataSet = LineChartDataSet(entries: dataEntry, label: "")
            lineDataSet.mode = .horizontalBezier
            
            lineDataSet.lineWidth = 3
            lineDataSet.drawCirclesEnabled = circleStatus
            lineDataSet.setCircleColor(UIColor(named: "Accent")!)
            lineDataSet.setColor(UIColor(named: "Accent")!)
            lineDataSet.circleRadius = 6
            lineDataSet.circleHoleColor = .white
            lineDataSet.circleHoleRadius = 4
            lineDataSet.drawValuesEnabled = false
            lineDataSet.drawHorizontalHighlightIndicatorEnabled = false
            lineDataSet.drawVerticalHighlightIndicatorEnabled = false
            
            let data = LineChartData()
            data.setDrawValues(false)
            data.addDataSet(lineDataSet)
            self.chart.data = data
            self.chart.invalidateIntrinsicContentSize()
        }
        
        showChart()
    }
    
    func showChart() {
        chartActivityIndicator.isHidden = true
        chart.isHidden = false
        chartSegmentedControl.isEnabled = true
    }

    @objc
	func shareItem() {
        var changeStatus = ""
        switch currency.status {
        case "high":
            changeStatus = "افزایش"
        case "low":
            changeStatus = "کاهش"
        default:
            break
        }
        let headerText = "🏷 " + currency.title + " " + currency.currentPrice
        let priceUpText = "📈 " + "بالاترین قیمت روز " + currency.priceUp
        let priceDownText = "📉 " + "پایین‌ترین قیمت روز " + currency.priceDown
        let priceChangeText = "🧮 " + "تغییرات قیمت: " + changeStatus + currency.priceChange
        let pricePercentChangeText = "📊 " + "درصد تغییرات قیمت: " + changeStatus + currency.percentChange
        let timeText = "🕰 " + updateLabel.text!
        let appAd = "اپ صرافی"
		
		let finalText = [
			headerText,
			priceUpText,
			priceDownText,
			priceChangeText,
			pricePercentChangeText,
			timeText,
			appAd
		].joined(separator: "\n")
		
        shareText(text: finalText, viewController: self)
    }
	
}

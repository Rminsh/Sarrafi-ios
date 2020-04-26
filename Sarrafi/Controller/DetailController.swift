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

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var chartSegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var percentChangeProgress: UICircularProgressRing!
    @IBOutlet weak var priceHighLabel: UILabel!
    @IBOutlet weak var priceLowLabel: UILabel!
    @IBOutlet weak var chartActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chart: LineChartView!
    
    var currency: CurrencyModel!
    
    var dateMonthly = [String]()
    var pricesMonthly = [Double]()
    
    var dateDaily = [String]()
    var pricesThreeMonths = [Double]()
    
    var dateThreeMonths = [String]()
    var pricesDaily = [Double]()
    
    var dateSixMonths = [String]()
    var pricesSixMonths = [Double]()
    
    var dateAllMonths = [String]()
    var pricesAllMonths = [Double]()
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_share"), style: .done, target: self, action: #selector(shareItem))
        chartSegmentedControl.setTitleTextAttributes([.font: UIFont(name: "Shabnam-FD", size: 12)!], for: UIControl.State.normal)
        
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
        chart.noDataFont = UIFont(name: "Shabnam-FD", size: 14)!
        
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
                    do {
                        let decoder = try JSONDecoder().decode(ChartStruct.self, from: response.data!)
                        
                        // Get Today chart
                        for item in decoder.today_table.reversed() {
                            self.dateDaily.append(item.time)
                            self.pricesDaily.append((item.price! as NSString).doubleValue)
                        }
                        
                        // Get Monthly Chart
                        let chart_1 = "[" + decoder.chart_1.replaceFirst(of: ".$", with: "") + "]"
                        let chart_1_data = chart_1.data(using: .utf8)
                        let decoder_chart_1 = try JSONDecoder().decode([NormalTable].self, from: chart_1_data!)
                        for item in decoder_chart_1 {
                            self.dateMonthly.append(String(item.jdate.suffix(5)))
                            self.pricesMonthly.append(item.value)
                        }
                        
                        // Get 3 Months Chart
                        let chart_3 = "[" + decoder.chart_3.replaceFirst(of: ".$", with: "") + "]"
                        let chart_3_data = chart_3.data(using: .utf8)
                        let decoder_chart_3 = try JSONDecoder().decode([NormalTable].self, from: chart_3_data!)
                        for item in decoder_chart_3 {
                            self.dateThreeMonths.append(String(item.jdate.suffix(5)))
                            self.pricesThreeMonths.append(item.value)
                        }
                        
                        // Get 6 Months Chart
                        let chart_6 = "[" + decoder.chart_6.replaceFirst(of: ".$", with: "") + "]"
                        let chart_6_data = chart_6.data(using: .utf8)
                        let decoder_chart_6 = try JSONDecoder().decode([NormalTable].self, from: chart_6_data!)
                        for item in decoder_chart_6 {
                            self.dateSixMonths.append(String(item.jdate.suffix(5)))
                            self.pricesSixMonths.append(item.value)
                        }
                        
                        //Get Chart Summery
                        let chart_summary = "[" + decoder.chart_summary + "]"
                        let chart_summary_data = chart_summary.data(using: .utf8)
                        let decoder_chart_summary = try JSONDecoder().decode([NormalTable].self, from: chart_summary_data!)
                        for item in decoder_chart_summary {
                            self.dateAllMonths.append(String(item.jdate.prefix(7)))
                            self.pricesAllMonths.append(item.value)
                        }
                        
                        self.loadFilters()
                        
                    } catch {
                        print(error)
                        self.showChart()
                    }
                case .failure:
                    print("Error")
                    self.showChart()
                }
        }
    }
    
    func loadFilters() {
        switch chartSegmentedControl.selectedSegmentIndex {
        case 0:
            // Today chart
            setDateChart(date: dateDaily)
            setDataChart(price: pricesDaily)
            break
        case 1:
            // Monthly Chart
            setDateChart(date: dateMonthly)
            setDataChart(price: pricesMonthly)
        case 2:
            // 3 Months Chart
            setDateChart(date: dateThreeMonths)
            setDataChart(price: pricesThreeMonths)
        case 3:
            // 6 Months Chart
            setDateChart(date: dateSixMonths)
            setDataChart(price: pricesSixMonths)
        case 4:
            // Chart Summery
            setDateChart(date: dateAllMonths)
            setDataChart(price: pricesAllMonths)
        default:
            break
        }
    }
    
    func setDateChart(date: [String]) {
        let xAxis = chart.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        let marker:BalloonMarker = BalloonMarker(
            date: date,
            priceType: currency.toCurrency,
            color: UIColor(named: "Accent")!,
            font: UIFont(name: "Shabnam-FD", size: 12)!,
            textColor: UIColor.white,
            insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0
        ))
         marker.minimumSize = CGSize(width: 75.0, height: 35.0)//CGSize(75.0, 35.0)
        chart.marker = marker
    }
    
    func setDataChart(price: [Double]) {
        
        var dataEntry = [ChartDataEntry]()
        let circleStatus = price.count <= 90
        
        for item in 0..<price.count {
            dataEntry.append(ChartDataEntry(x: Double(item), y: Double(price[item])))
        }
        
        let lineDataSet = LineChartDataSet(entries: dataEntry, label: "")
        lineDataSet.mode = .horizontalBezier
        
        lineDataSet.lineWidth = 3
        lineDataSet.drawCirclesEnabled = circleStatus
        lineDataSet.setCircleColor(UIColor(named: "Accent")!)
        lineDataSet.setColor(UIColor(named: "Accent")!)
        lineDataSet.circleRadius = 6
        lineDataSet.circleHoleColor = UIColor.white
        lineDataSet.circleHoleRadius = 4
        lineDataSet.drawValuesEnabled = false
        lineDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineDataSet.drawVerticalHighlightIndicatorEnabled = false
        
        let data = LineChartData()
        data.setDrawValues(false)
        data.addDataSet(lineDataSet)
        chart.data = data
        chart.invalidateIntrinsicContentSize()
        
        showChart()
    }
    
    func showChart() {
        self.chartActivityIndicator.isHidden = true
        self.chart.isHidden = false
        chartSegmentedControl.isEnabled = true
    }

    @objc func shareItem() {
        var changeStatus = ""
        switch currency.status {
        case "high":
            changeStatus = "افزایش"
            break
        case "low":
            changeStatus = "کاهش"
            break
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
        shareText(text: headerText + "\n" + priceUpText + "\n" + priceDownText + "\n" + priceChangeText + "\n" + pricePercentChangeText + "\n" + timeText + "\n" + appAd , viewController: self)
    }
}

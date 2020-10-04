//
//  CurrencyService+ChartMethod.swift
//  Sarrafi
//
//  Created by Omid Golparvar on 10/4/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Foundation
import Alamofire

extension CurrencyService {
	
	func getChart(for currency: CurrencyModel, completion: @escaping (Result<Charts, NetworkingError>)-> Void) {
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
						let chart = try JSONDecoder().decode(ChartStruct.self, from: response.data!)
						
						let chart_Day			: ChartItem?
						let chart_Month			: ChartItem?
						let chart_ThreeMonths	: ChartItem?
						let chart_SixMonths		: ChartItem?
						let chart_Summary		: ChartItem?
						
						// TODO: Today Chart has slow performance on UI
						// Get Today chart
						chart_Day = .init(dates: [], prices: [])
						/* for item in decoder.today_table.reversed() {
							let price = Double(item.price.replacingOccurrences(of: ",", with: "", options: .literal, range: nil))
							self.dateDaily.append(item.time)
							self.pricesDaily.append(price!)
						}*/
						
						// Get Monthly Chart
						let chart_1 = "[" + chart.chart_1.replaceFirst(of: ".$", with: "") + "]"
						if let chart_1_data = chart_1.data(using: .utf8),
						   let chart_1_table = try? JSONDecoder().decode([NormalTable].self, from: chart_1_data) {
							let dates = chart_1_table.map { String($0.jdate.suffix(5)) }
							let prices = chart_1_table.map(\.value)
							chart_Month = ChartItem(dates: dates, prices: prices)
						} else {
							chart_Month = nil
						}
						
						// Get 3 Months Chart
						let chart_3 = "[" + chart.chart_3.replaceFirst(of: ".$", with: "") + "]"
						if let chart_3_data = chart_3.data(using: .utf8),
						   let chart_3_table = try? JSONDecoder().decode([NormalTable].self, from: chart_3_data) {
							let dates = chart_3_table.map { String($0.jdate.suffix(5)) }
							let prices = chart_3_table.map(\.value)
							chart_ThreeMonths = ChartItem(dates: dates, prices: prices)
						} else {
							chart_ThreeMonths = nil
						}
						
						// Get 6 Months Chart
						let chart_6 = "[" + chart.chart_6.replaceFirst(of: ".$", with: "") + "]"
						if let chart_6_data = chart_6.data(using: .utf8),
						   let chart_6_table = try? JSONDecoder().decode([NormalTable].self, from: chart_6_data) {
							let dates = chart_6_table.map { String($0.jdate.suffix(5)) }
							let prices = chart_6_table.map(\.value)
							chart_SixMonths = ChartItem(dates: dates, prices: prices)
						} else {
							chart_SixMonths = nil
						}
						
						//Get Chart Summery
						let chart_summary = "[" + chart.chart_summary + "]"
						if let chart_summary_data = chart_summary.data(using: .utf8),
						   let chart_summary_table = try? JSONDecoder().decode([NormalTable].self, from: chart_summary_data) {
							let dates = chart_summary_table.map { String($0.jdate.suffix(5)) }
							let prices = chart_summary_table.map(\.value)
							chart_Summary = ChartItem(dates: dates, prices: prices)
						} else {
							chart_Summary = nil
						}
						
						guard let _0 = chart_Day,
							  let _1 = chart_Month,
							  let _2 = chart_ThreeMonths,
							  let _3 = chart_SixMonths,
							  let _4 = chart_Summary
						else {
							completion(.failure(.parsingError))
							return
						}
						
						let charts = Charts(day: _0, month: _1, threeMonths: _2, sixMonths: _3, summary: _4)
						completion(.success(charts))
						
					} catch {
						print(error)
						completion(.failure(.parsingError))
					}
				case .failure:
					print("Error")
					completion(.failure(.connectionIssue))
				}
		}
	}
	
}

//
//  Charts.swift
//  Sarrafi
//
//  Created by Omid Golparvar on 10/4/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Foundation

struct Charts {
	let day			: ChartItem
	let month		: ChartItem
	let threeMonths	: ChartItem
	let sixMonths	: ChartItem
	let summary		: ChartItem
}

struct ChartItem {
	let dates: [String]
	let prices: [Double]
}

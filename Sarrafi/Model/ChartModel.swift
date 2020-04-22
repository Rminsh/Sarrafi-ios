//
//  ChartModel.swift
//  Sarrafi
//
//  Created by armin on 4/22/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Foundation

// MARK: - ChartStruct
struct ChartStruct : Codable {
    let chart_summary: String
    let data_chart, currency: String
    let is_today: Bool
    let today_vs_yesterday_chart, chart_15, chart_1, chart_3, chart_6: String
    let chart_detail: [String: [String]]
    let invest: [String: String]
    let today_table: [TodayTable]
    let title: String
}

// MARK: - TodayTable
struct TodayTable: Codable {
    let type: String
    let price: String
    let time: String
}

// MARK: - NormalTable
struct NormalTable: Codable {
    let date, jdate: String
    let value: Int
}

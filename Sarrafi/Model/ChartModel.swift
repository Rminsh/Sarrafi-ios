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
    let type: String!
    var _price: RelaxedString?
    let time: String!
    
    var price: String! {
        get { _price!.value }
        set { _price = newValue.map(RelaxedString.init) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case _price = "price"
        case time = "time"
    }

    init(type: String? = nil, price: String? = nil, time: String? = nil) {
        self.type = type
        self._price = price.map(RelaxedString.init)
        self.time = time
    }
}

struct RelaxedString: Codable {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // attempt to decode from all JSON primitives
        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = String(int)
        } else if let double = try? container.decode(Double.self) {
            value = String(double)
        } else if let bool = try? container.decode(Bool.self) {
            value = String(bool)
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - NormalTable
struct NormalTable: Codable {
    let jdate: String
    let value: Double
}

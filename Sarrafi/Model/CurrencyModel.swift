//
//  CurrencyStruct.swift
//  Sarrafi
//
//  Created by armin on 10/18/19.
//  Copyright © 2020 Sarrafi. All rights reserved.
//
//   let currencyStruct = try? newJSONDecoder().decode(CurrencyStruct.self, from: jsonData)

import Foundation

// MARK: - Currency Model Class

class CurrencyModel {
    private var _object : String!
    private var _title : String!
    private var _currentPrice : String!
    private var _toCurrency: String!
    private var _status : String!
    private var _priceUp : String!
    private var _priceDown : String!
    private var _percentChange : String!
    private var _priceChange : String!
    private var _updateTime : String!
    
    var object: String {
        return _object
    }
    
    var title: String {
        return _title
    }
    
    var currentPrice: String {
        return _currentPrice
    }
    
    var toCurrency: String {
        return _toCurrency
    }
    
    var status: String {
        return _status
    }
    
    var priceUp: String {
        return _priceUp
    }
    
    var priceDown: String {
        return _priceDown
    }
    
    var percentChange: String {
        return _percentChange
    }
    
    var priceChange: String {
        return _priceChange
    }
    
    var updateTime: String {
        return _updateTime
    }

    init(object: String, title: String, currentPrice: String, toCurrency: String, status: String, priceUp: String, priceDown: String, percentChange: String, priceChange: String, updateTime: String) {
        _object = object
        _title = title
        _currentPrice = currentPrice
        _toCurrency = toCurrency
        _status = status
        _priceUp = priceUp
        _priceDown = priceDown
        _percentChange = percentChange
        _priceChange = priceChange
        _updateTime = updateTime
    }
}

// MARK: - CurrencyStruct
struct CurrencyStruct: Codable {
    let current: Current
}

// MARK: - Current
struct Current: Codable {

    let price_dollar_rl: CurrencyDetail
    let price_dollar_soleymani: CurrencyDetail
    let price_eur: CurrencyDetail
    let price_cad: CurrencyDetail
    let price_gbp: CurrencyDetail
    let price_aed: CurrencyDetail
    let price_try: CurrencyDetail
    let price_cny: CurrencyDetail
    let price_jpy: CurrencyDetail
    let price_afn: CurrencyDetail
    let price_iqd: CurrencyDetail
    let price_myr: CurrencyDetail
    let price_rub: CurrencyDetail
    let price_inr: CurrencyDetail
    
    let sekee: CurrencyDetail
    let sekeb: CurrencyDetail
    let nim: CurrencyDetail
    let rob: CurrencyDetail
    let geram24: CurrencyDetail
    let geram18: CurrencyDetail
    let mesghal: CurrencyDetail
    let gerami: CurrencyDetail
    let ons: CurrencyDetail
    let silver: CurrencyDetail
    let gold_mini_size: CurrencyDetail
    
    let bitcoin: CurrencyDetail
    let ethereum: CurrencyDetail
    let ripple: CurrencyDetail
    let dash: CurrencyDetail
    let litecoin: CurrencyDetail
    let stellar: CurrencyDetail


    enum CodingKeys: String, CodingKey {
        
        // MARK: - Currency
        case price_dollar_rl            //American Dollar
        case price_dollar_soleymani     //Soleymanie Dollar
        case price_eur                  //Euro
        case price_cad                  //Canada Dollar
        case price_gbp                  //England Pound
        case price_aed                  //United Arab Emirates dirham
        case price_try                  //Turkish lira
        case price_cny                  //Chinese Yuan
        case price_jpy                  //Japanese Yen
        case price_afn                  //Afghan Afghani
        case price_iqd                  //Iraqi Dinar
        case price_myr                  //Malaysian Ringgit
        case price_rub                  //Russian Ruble
        case price_inr                  //Indian Rupee
        
        // MARK: - Gold and Coins
        case sekee      //Seke Emami
        case sekeb      //Seke bahare azadi
        case nim        //Seke nim
        case rob        //Seke rob
        case geram24    //Tala geram 24
        case geram18    //Tala geram 18
        case mesghal    //Tala mesghal
        case gerami     //Seke Gerami
        case ons        //Ons Tala
        case silver     //Noghre
        case gold_mini_size
        
        // MARK: - Digital Currency
        case bitcoin = "crypto-bitcoin"
        case ethereum = "crypto-ethereum"
        case ripple = "crypto-ripple"
        case dash = "crypto-dash"
        case litecoin = "crypto-litecoin"
        case stellar = "crypto-stellar"
        
    }
}

// MARK: - CurrencyDetail
struct CurrencyDetail: Codable {
    let p: String
    let h: String
    let l: String
    let d: String
    let dp: Double
    let dt: String
    let t: String
    let tEn: String
    let tG: String
    let ts: String
    let settlement: String?
    let r: String?

    enum CodingKeys: String, CodingKey {
        case p
        case h
        case l
        case d
        case dp
        case dt
        case t
        case tEn = "t_en"
        case tG = "t-g"
        case ts
        case settlement
        case r
    }
}

struct currency {
    static let rial = "ریال"
    static let dollar = "دلار"
}

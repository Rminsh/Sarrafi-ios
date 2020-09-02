//
//  CurrencyListResponse.swift
//  Sarrafi
//
//  Created by armin on 5/8/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Foundation

struct CurrencyListResponse {
    var currencyStats = [CurrencyModel]()
    
    init(currencyStruct: CurrencyStruct) {
        
        addObj(currencyObject: currencyStruct.current.price_dollar_rl, currencyName: Current.CodingKeys.price_dollar_rl.rawValue, title: "دلار آمریکا", toCurrency:currency.rial)
        addObj(currencyObject: currencyStruct.current.price_dollar_soleymani, currencyName: Current.CodingKeys.price_dollar_soleymani.rawValue, title: "دلار سلیمانیه", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_eur, currencyName: Current.CodingKeys.price_eur.rawValue, title: "یورو", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_cad, currencyName: Current.CodingKeys.price_cad.rawValue, title: "دلار کانادا", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_gbp, currencyName: Current.CodingKeys.price_gbp.rawValue, title: "پوند انگلیس", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_aed, currencyName: Current.CodingKeys.price_aed.rawValue, title: "درهم امارات", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_try, currencyName: Current.CodingKeys.price_try.rawValue, title: "لیر ترکیه", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_cny, currencyName: Current.CodingKeys.price_cny.rawValue, title: "یوان چین", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_jpy, currencyName: Current.CodingKeys.price_jpy.rawValue, title: "ین ژاپن", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_afn, currencyName: Current.CodingKeys.price_afn.rawValue, title: "افغانی", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_iqd, currencyName: Current.CodingKeys.price_iqd.rawValue, title: "دینار عراق", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_myr, currencyName: Current.CodingKeys.price_myr.rawValue, title: "رینگیت مالزی", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_rub, currencyName: Current.CodingKeys.price_rub.rawValue, title: "روبل روسیه", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.price_inr, currencyName: Current.CodingKeys.price_inr.rawValue, title: "روپیه هند", toCurrency: currency.rial)
        
        addObj(currencyObject: currencyStruct.current.sekee, currencyName: Current.CodingKeys.sekee.rawValue, title: "سکه امامی", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.sekeb, currencyName: Current.CodingKeys.sekeb.rawValue, title: "سکه بهار آزادی", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.nim, currencyName: Current.CodingKeys.nim.rawValue, title: "نیم سکه", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.rob, currencyName: Current.CodingKeys.rob.rawValue, title: "ربع سکه", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.geram24, currencyName: Current.CodingKeys.geram24.rawValue, title: "طلای ۲۴ عیار", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.geram18, currencyName: Current.CodingKeys.geram18.rawValue, title: "طلای ۱۸ عیار", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.mesghal, currencyName: Current.CodingKeys.mesghal.rawValue, title: "مثقال طلا", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.gerami, currencyName: Current.CodingKeys.gerami.rawValue, title: "سکه گرمی", toCurrency: currency.rial)
        addObj(currencyObject: currencyStruct.current.ons, currencyName: Current.CodingKeys.ons.rawValue, title: "انس طلا", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.silver, currencyName: Current.CodingKeys.silver.rawValue, title: "انس نقره", toCurrency: currency.dollar)
        
        addObj(currencyObject: currencyStruct.current.bitcoin, currencyName: Current.CodingKeys.bitcoin.rawValue, title: "بیت کوین / Bitcoin", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.ethereum, currencyName: Current.CodingKeys.ethereum.rawValue, title: "اتریوم / Ethereum", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.ripple, currencyName: Current.CodingKeys.ripple.rawValue, title: "ریپل / Ripple", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.dash, currencyName: Current.CodingKeys.dash.rawValue, title: "دش / Dash", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.litecoin, currencyName: Current.CodingKeys.litecoin.rawValue, title: "لایت کوین/Litecoin", toCurrency: currency.dollar)
        addObj(currencyObject: currencyStruct.current.stellar, currencyName: Current.CodingKeys.stellar.rawValue, title: "استلار / Stellar", toCurrency: currency.dollar)
    }
    
    mutating func addObj(currencyObject: CurrencyDetail, currencyName: String, title: String, toCurrency: String) {
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
}

//
//  CurrencyRealTimeRate.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/29.
//

import Foundation

struct CurrencyRealTimeRate: Codable {
    let name: String
    let symbol: String
    let price: String
    let logo_url: String
}

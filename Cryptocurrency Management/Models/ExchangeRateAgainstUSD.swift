//
//  ExchangeRateAgainstUSD.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/02/01.
//

import Foundation

struct ExchangeRateAgainstUSD: Codable {
    let rates: Rates
    struct Rates: Codable {
        let CAD: Double
    }
    let base: String
    let date: String
    
}

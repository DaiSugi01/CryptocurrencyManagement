//
//  CurrencyPriceTimeSeries.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/25.
//

import Foundation

struct CurrencyPriceTimeSeries: Codable {
    let data: Data
    
    struct Data: Codable {
 
        let parameters: Parameters
        let values: [[Double]]

        struct Parameters: Codable {
            let start: String
            let end: String
        }
    }
}

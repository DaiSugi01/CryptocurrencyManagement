//
//  CurrencyList.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/25.
//

import Foundation

struct CurrencyList: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let symbol: String
        let name: String
    }
}

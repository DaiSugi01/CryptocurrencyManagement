//
//  OrderbookContents.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/30.
//

import Foundation

struct OrderbookContents: Codable {
    let baseSymbol: String  // target currency
    let quoteSymbol: String  // the price of the target currency is shown in this currency
//    let orderBooks: [String: String] // exchange and orderBook
//    let orderBook: String
//    let asks: [String: String]
//    let bids: [String: String]
}

//
//  OrderBook.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/24.
//

import Foundation

struct OrderBook {
    enum OrderBookType {
        case ask
        case bid
    }
    var currencyName: String
    var price: Double
    var amount: Double
    var orderBookType: OrderBookType
}

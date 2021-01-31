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
    let orderBooks: [OrderBooks]
    struct OrderBooks: Codable {
        let exchange: String
        let orderBook: OrderBook
        struct OrderBook: Codable {
          let asks: [Ask]
          let bids: [Bid]
          struct Ask: Codable {
            let price: String
            let quantity: String
          }
          struct Bid: Codable {
            let price: String
            let quantity: String
          }
        }
      }
}

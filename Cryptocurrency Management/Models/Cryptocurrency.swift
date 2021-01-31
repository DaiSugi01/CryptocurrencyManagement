//
//  Cryptocurrency.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/21.
//
import Foundation

struct Cryptocurrency: Codable, Equatable {
    var name: String
    var symbol: String
    var realTimeRate: Double?
    var lowPrice: Double?
    var highPrice: Double?
    var image: String
    
    static func ==(lhs: Cryptocurrency, rhs: Cryptocurrency) -> Bool {
        return lhs.name == rhs.name
    }
}

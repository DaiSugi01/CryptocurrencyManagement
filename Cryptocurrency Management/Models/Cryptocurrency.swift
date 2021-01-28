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
    var price: Double
    
    static func ==(lhs: Cryptocurrency, rhs: Cryptocurrency) -> Bool {
        return lhs.name == rhs.name
    }
}

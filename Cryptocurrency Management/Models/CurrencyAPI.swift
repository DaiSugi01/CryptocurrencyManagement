//
//  CurrencyAPI.swift
//  Cryptocurrency Management
//
//  Created by 杉原大貴 on 2021/01/25.
//

import Foundation
import UIKit

class CurrencyAPI {
    
    static let shared = CurrencyAPI()
    
    private var dataTask: URLSessionDataTask?
    
    private init() {}
    
    func fetchCurrencyList(completion: @escaping (Result<CurrencyList, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: Endpoint.Messari.assetsUrl)!
        urlComponents.queryItems = [
            Parameter.Messari.fields: "symbol,name"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        fetch(from: urlComponents.url!) { (result: Result<CurrencyList, NetworkError>) in
            completion(result)
        }
    }
    
    func fetchCryptocurrencyFromNomics(currencySymbols: String, completion: @escaping (Result<[CurrencyRealTimeRate], NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: Endpoint.Nomics.namePriceUrl)!
        urlComponents.queryItems = [
            Parameter.Nomics.apiKey: CurrencyAPIKey.nomicsAPIKey,
            Parameter.Nomics.ids: currencySymbols,
            Parameter.Nomics.interval: "1d",
            Parameter.Nomics.convert: "CAD"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        fetch(from: urlComponents.url!) { (result: Result<[CurrencyRealTimeRate], NetworkError>) in
          completion(result)
        }
    }
    
    func fetchOrderbookFromShrimpy(targetCurrency: String, completion: @escaping (Result<[OrderbookContents], NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: Endpoint.Shrimpy.orderbookUrl)!
        urlComponents.queryItems = [
            Parameter.Shrimpy.apiKey: CurrencyAPIKey.shrimpyPrivateApiKey,
            Parameter.Shrimpy.exchange: "Bittrex",
            Parameter.Shrimpy.targetCurrency: targetCurrency,
            Parameter.Shrimpy.priceIn: "USDT",
            Parameter.Shrimpy.maxNum: "10"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        fetch(from: urlComponents.url!) { (result: Result<[OrderbookContents], NetworkError>) in
            completion(result)
        }
    }
    
    func fetchCurrencyPriceTimeSeries(currency: String, completion: @escaping (Result<CurrencyPriceTimeSeries, NetworkError>) -> Void) {
        
        // current date
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = dateFormatter.string(from: date)
        
        // 1 years ago date from current
        let calculated = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        let startDate = dateFormatter.string(from: calculated)

        // replace currency name to make url
        let currencySymbol = currency.lowercased()
        let regex = try! NSRegularExpression(pattern: "/assets/[a-z]*/", options: .caseInsensitive)
        let newUrl = regex.stringByReplacingMatches(in: Endpoint.Messari.priceTimeSeriesUrl, options: [], range: NSRange(0..<Endpoint.Messari.priceTimeSeriesUrl.utf16.count), withTemplate: "/assets/\(currencySymbol)/")
        
        var urlComponents = URLComponents(string: newUrl)!
        urlComponents.queryItems = [
            Parameter.Messari.startDate : startDate,
            Parameter.Messari.endDate : endDate,
            Parameter.Messari.interval : "1d",
            Parameter.Messari.columns : "close"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        fetch(from: urlComponents.url!) { (result: Result<CurrencyPriceTimeSeries, NetworkError>) in
            completion(result)
        }
    }
    
    var nonce = 0
    private func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(CurrencyAPIKey.shrimpyPrivateApiKey, forHTTPHeaderField: "SHRIMPY-API-KEY")
        nonce += 1
        request.setValue("\(nonce)", forHTTPHeaderField: "DEV-SHRIMPY-API-NONCE")
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.client(message: "invalid request")))
                return
            }
            
            guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                completion(.failure(.server))
                return
            }
            
            do {
                guard let data = data else {
                    completion(.failure(.client(message: "response body(data) is nil")))
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.client(message: error.localizedDescription)))
            }
        }
        dataTask?.resume()
    }
    
    struct Endpoint {
        
        struct Messari {
            static let assetsUrl = "https://data.messari.io/api/v2/assets"
            static let priceTimeSeriesUrl = "https://data.messari.io/api/v1/assets/currencyName/metrics/price/time-series"
        }
        
        struct Nomics {
            static let namePriceUrl = "https://api.nomics.com/v1/currencies/ticker"
        }
        
        struct Shrimpy {
            static let orderbookUrl = "https://dev-api.shrimpy.io/v1/orderbooks"
        }
    }
    
    struct Parameter {
        struct Messari {
            static let fields = "fields"
            static let startDate = "start"
            static let endDate = "end"
            static let interval = "interval"
            static let columns = "columns"
        }
        
        struct Nomics {
            static let apiKey = "key"
            static let ids = "ids"
            static let interval = "interval"
            static let convert = "convert"
        }
        
        struct Shrimpy {
            static let apiKey = "apiKey"
            static let exchange = "exchange"
            static let targetCurrency = "baseSymbol"
            static let priceIn = "quoteSymbol"
            static let maxNum = "limit"
        }
    }
    
    enum NetworkError: Error {
        case client(message: String)
        case server
    }
}

extension CurrencyAPI.NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .server:
            return NSLocalizedString("Server error!", comment: "")
        case .client(let message):
            return NSLocalizedString("Client error! - \(message)", comment: "")
        }
    }
}

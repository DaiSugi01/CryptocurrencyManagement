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
    
    private func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        dataTask?.cancel()
        print(url)
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
            static let assetsUrl = "https://data.messari.io/api/v2/asse"
        }
    }
    
    struct Parameter {
        struct Messari {
            static let fields = "fields"
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

//
//  ApiManager.swift
//  Converter
//
//  Created by Victor Mashukevich on 3.11.24.
//

import Foundation

enum DataError: Error {
    case invalidData
    case invalidResponse(code: Int)
    case message(_ error: Error?)
}

protocol ApiManager {
    func fetchData(completion: @escaping (Result<ExchangeRatesResponse, Error>) -> Void)
}

class VCApiManager: ApiManager {
    
    private let apiKey = "723c1f69e98dbdebcadcfc86630cdfcc"
    
    func fetchData(completion: @escaping (Result<ExchangeRatesResponse, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "https://data.fixer.io/api/latest")
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(DataError.invalidData))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(DataError.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse(code: 0)))
                return
            }
            
            guard 200 ... 299 ~= response.statusCode else {
                completion(.failure(DataError.invalidResponse(code: response.statusCode)))
                return
            }
            
            do {
                let exchangeRates = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(exchangeRates))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(DataError.message(error)))
                }
            }
        }.resume()
    }
}

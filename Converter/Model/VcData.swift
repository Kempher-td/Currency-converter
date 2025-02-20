//
//  VcData.swift
//  Converter
//
//  Created by Victor Mashukevich on 25.10.24.
//

import Foundation


struct ExchangeRatesResponse: Decodable {
    
    let success: Bool?
    let rates: [String: Double]
    let base: String?
    let date: String
    
}



//
//  DetailResponse.swift
//  StocksApp
//
//  Created by Dilyara on 01.06.2022.
//

import Foundation

struct Chart: Decodable {
    let prices: [[Double]]
    
    struct Price: Decodable {
        let date: Date
        let price: Double
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let array = try container.decode([Double].self)
                        
            guard let date = array[safe: 0],
                  let price = array[safe: 1] else {
                throw NSError(domain: "Bad model from json", code: 500, userInfo: nil)
            }
                        
            self.date = Date(timeIntervalSince1970: TimeInterval(date))
            self.price = price
        }
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

//
//  ChartsModel.swift
//  StocksApp
//
//  Created by Dilyara on 08.06.2022.
//

import Foundation

struct ChartsModel {
    let periods: [Period]
    
    struct Period {
        let name: String
        let prices: [Double]
    }
    
    static func build(from charts: Charts) -> ChartsModel {
        return ChartsModel(periods: [Period(name: "W", prices: calculatePeriod(prices:                                        charts.prices.map { $0.price }, periodType: "W")),
                                     Period(name: "M", prices: calculatePeriod(prices: charts.prices.map { $0.price }, periodType: "M")),
                                     Period(name: "6M", prices: calculatePeriod(prices: charts.prices.map { $0.price }, periodType: "6M")),
                                     Period(name: "1Y", prices: charts.prices.map { $0.price })])
    }
    
    static func calculatePeriod(prices: [Double], periodType: String) -> [Double] {
        switch periodType {
        case "W":
            return Array(prices.suffix(7))
        case "M":
            return Array(prices.suffix(30))
        case "6M":
            return Array(prices.suffix(180))
        default:
            return []
        }
    }
}

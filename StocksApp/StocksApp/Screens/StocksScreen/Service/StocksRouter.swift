//
//  StocksRouter.swift
//  StocksApp
//
//  Created by Dilyara on 31.05.2022.
//

import Foundation

enum StocksRouter: Router {
    case stocks(carrency: String, count: String)
    case charts(carrency: String, days: String, interval: String)
    
    var baseUrl: String {
        "https://api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "/api/v3/coins/markets"
        case .charts:
            return "/api/v3/coins/bitcoin/market_chart"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stocks:
            return .get
        case .charts:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .stocks(let carrency, let count):
            return ["vs_currency": carrency, "per_page": count]
        case .charts(carrency: let carrency, days: let days, interval: let interval):
            return ["vs_currency": carrency, "days": days, "interval": interval]
        }
    }
}

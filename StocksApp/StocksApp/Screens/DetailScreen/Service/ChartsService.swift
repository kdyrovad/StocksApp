//
//  ChartsService.swift
//  StocksApp
//
//  Created by Dilyara on 08.06.2022.
//

import Foundation

protocol ChartsServiceProtocol {
    func getCharts(id: String, currency: String, days: String, interval: String, completion: @escaping (Result<Charts, NetworkError>) -> Void)
    func getCharts(id: String, completion: @escaping (Result<Charts, NetworkError>) -> Void)
}

final class ChartsService: ChartsServiceProtocol {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func getCharts(id: String, currency: String, days: String, interval: String, completion: @escaping (Result<Charts, NetworkError>) -> Void) {
        network.execute(with: StocksRouter.charts(carrency: currency, days: days, interval: interval, id: id), completion: completion)
    }
}

extension ChartsServiceProtocol {
    func getCharts(id: String, completion: @escaping (Result<Charts, NetworkError>) -> Void) {
        getCharts(id: id, currency: "usd", days: "100", interval: "daily", completion: completion)
    }
}

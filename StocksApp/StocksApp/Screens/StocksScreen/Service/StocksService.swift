//
//  StocksService.swift
//  StocksApp
//
//  Created by Dilyara on 30.05.2022.
//

import Foundation

protocol StocksServiceProtocol {
    func getStocks(carrency: String, count: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func getStocks(carrency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func getStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func getStocks(view: StocksViewProtocol?) -> [StockModelProtocol]
    
    func getChart(id: String, carrency: String, days: String, interval: String, completion: @escaping (Result<Chart, NetworkError>) -> Void)
    func getChart(carrency: String, completion: @escaping (Result<Chart, NetworkError>) -> Void)
    func getChart(completion: @escaping (Result<Chart, NetworkError>) -> Void)
}

final class StocksService: StocksServiceProtocol {
    
    private let client: NetworkService
    
    private var stocks: [StockModelProtocol] = []
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func getStocks(carrency: String, count: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        client.execute(with: StocksRouter.stocks(carrency: carrency, count: count), completion: completion)
    }
    
    func getStocks(view: StocksViewProtocol?) -> [StockModelProtocol] {
        if stocks.isEmpty {
            print("EMPTYYYY")
            view?.updateView(withLoader: true)
            self.getStocks { [weak self] result in
                view?.updateView(withLoader: false)
                
                switch result {
                case .success(let stock):
                    self?.stocks = stock.map { StockModel(stock: $0) }
                    print("SUCCESS")
                    view?.updateView()
                case .failure(let error):
                    view?.updateView(withError: error.localizedDescription)
                }
            }
        } else {
            print("NOoooT EMPTYYYY")
        }
        
        return stocks
    }
    
    func getChart(id: String, carrency: String, days: String, interval: String, completion: @escaping (Result<Chart, NetworkError>) -> Void) {
        client.execute(with: StocksRouter.charts(carrency: carrency, days: days, interval: interval, id: id), completion: completion)
    }
}

extension StocksServiceProtocol {
    func getStocks(carrency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        getStocks(carrency: carrency, count: "100", completion: completion)
    }
    
    func getStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        getStocks(carrency: "usd", completion: completion)
    }
    
    func getChart(carrency: String, completion: @escaping (Result<Chart, NetworkError>) -> Void) {
        getChart(id: "", carrency: carrency, days: "60", interval: "daily", completion: completion)
    }
    
    func getChart(completion: @escaping (Result<Chart, NetworkError>) -> Void) {
        getChart(carrency: "usd", completion: completion)
    }
}

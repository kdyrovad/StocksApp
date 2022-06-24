//
//  SearchPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 09.06.2022.
//

import Foundation

protocol SearchPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    
    func loadView()
    func modelSearch(for indexPath: IndexPath, text: String) -> StockModelProtocol
    var searchItemsCount: Int { get }
    func searchItemsCountChanged(text: String)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private let service: StocksServiceProtocol
    private var stocks: [StockModelProtocol] = []
    
    var searchItemsCount: Int = 0
    
    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    weak var view: StocksViewProtocol?
    
    func loadView() {
        view?.updateView(withLoader: true)
        
        service.getStocks { [weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result {
            case .success(let stocks):
                self?.stocks = stocks
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
    }
     
    func searchItemsCountChanged(text: String) {
        searchItemsCount = text.isEmpty ? 0 : stocks.filter{ $0.name.starts(with: text) }.count
    }

    func modelSearch(for indexPath: IndexPath, text: String) -> StockModelProtocol {
        return stocks.filter{ $0.name.starts(with: text) }[indexPath.row]
    }
}


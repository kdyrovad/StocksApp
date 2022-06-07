//
//  FavoritesPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 03.06.2022.
//

import Foundation

//protocol StocksViewProtocol: AnyObject {
//    func updateView()
//    func updateView(withLoader isLoading: Bool)
//    func updateView(withError message: String)
//    func updateCell(for indexPath: IndexPath)
//    //func updateStocksArray()
//}

protocol FavoritesPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    var itemsCount: Int { get }
    
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
    func updateStocksArray()
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    var itemsCount: Int {
        stocks.count
    }

    private let service: StocksServiceProtocol
    private var stocks: [StockModelProtocol] = []
    
    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    weak var view: StocksViewProtocol?
    
    func loadView() {
        startFavoritesNotificationObserving()
        
        view?.updateView(withLoader: true)
        
        stocks = service.getStocks(view: view)
        
//        view?.updateView(withLoader: true)
//        service.getStocks { [weak self] result in
//            self?.view?.updateView(withLoader: false)
//
//            switch result {
//            case .success(let stocks):
//                self?.stocks = stocks.map { StockModel(stock: $0) }
//                self?.view?.updateView()
//            case .failure(let error):
//                self?.view?.updateView(withError: error.localizedDescription)
//            }
//        }
    }
    
    func setStocks(stocks: [StockModelProtocol]) {
        self.stocks = stocks
    }
    
    func getStocks() -> [StockModelProtocol] {
        return self.stocks
    }
    
    func updateStocksArray() {
        setStocks(stocks: getStocks().filter{ $0.isFav })
    }
    
//    static func updateStocksArray() {
//        FavoritesPresenter.stocks = FavoritesPresenter.stocks.filter { StockModel(stock: $0).isFav }.map { StockModel(stock: $0) }
//    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        stocks[indexPath.section]
    }
}

extension FavoritesPresenter: FavoritesUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = stocks.firstIndex(where: { $0.id == id }) else { return }
        let indexPath = IndexPath(row: 0, section: index)
        
        view?.updateCell(for: indexPath)
    }
}




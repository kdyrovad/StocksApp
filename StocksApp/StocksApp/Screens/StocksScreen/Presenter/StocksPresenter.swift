//
//  StocksPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 31.05.2022.
//

import Foundation

protocol StocksViewProtocol: AnyObject {
    func updateView()
    func updateCell(for indexPath: IndexPath)
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}

protocol StocksPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    var itemsCount: Int { get }
    
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
    
    func modelForFavorites(for indexPath: IndexPath) -> StockModelProtocol
    var favoriteItemsCount: Int { get }
    
    func giveStocks() -> [StockModelProtocol]
}

final class StocksPresenter: StocksPresenterProtocol {
    var itemsCount: Int {
        stocks.count
    }
    
    var favoriteItemsCount: Int {
        stocksFavorites.count
    }

    private let service: StocksServiceProtocol
    private var stocks: [StockModelProtocol] = []
    private var stocksFavorites: [StockModelProtocol] = []
    
    init(service: StocksServiceProtocol) {
        self.service = service
    }
    
    weak var view: StocksViewProtocol?
    
    func loadView() {
        startFavoritesNotificationObserving()
        
//        print("HELLOOOOO")
//        self.stocks = service.getStocks(view: view)
//        print("HELLOOOOO2")
        view?.updateView(withLoader: true)
        service.getStocks { [weak self] result in
            self?.view?.updateView(withLoader: false)

            switch result {
            case .success(let stocks):
                self?.stocks = stocks.map { StockModel(stock: $0) }
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
        stocksFavorites = stocks.filter{ $0.isFav }
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        stocks[indexPath.section]
    }
    
    func modelForFavorites(for indexPath: IndexPath) -> StockModelProtocol {
        stocksFavorites[indexPath.section]
    }
    
    func giveStocks() -> [StockModelProtocol] {
        return stocks
    }
}

extension StocksPresenter: FavoritesUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = stocks.firstIndex(where: { $0.id == id }) else { return }
        let indexPath = IndexPath(row: 0, section: index)
        view?.updateCell(for: indexPath)
    }
}


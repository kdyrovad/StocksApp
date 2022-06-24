//
//  FavoritesPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 03.06.2022.
//

import Foundation

protocol FavoritesPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    var itemsCount: Int { get }
    
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    var itemsCount: Int {
        stocks.count
    }

    private let service: StocksServiceProtocol
    private var stocks: [StockModelProtocol] = []
    
    init(service: StocksServiceProtocol) {
        self.service = service
        startFavoritesNotificationObserving()
    }
    
    weak var view: StocksViewProtocol?
    
    func loadView() {
        view?.updateView(withLoader: true)
        
        service.getStocks { [weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result {
            case .success(let stocks):
                self?.stocks = stocks.filter{ $0.isFav }
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        stocks[indexPath.row]
    }
}

extension FavoritesPresenter: FavoritesUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = stocks.firstIndex(where: { $0.id == id }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        
        view?.updateCell(for: indexPath)
    }
}




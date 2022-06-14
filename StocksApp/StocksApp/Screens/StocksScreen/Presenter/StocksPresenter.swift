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
}

final class StocksPresenter: StocksPresenterProtocol {
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
                self?.stocks = stocks
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

extension StocksPresenter: FavoritesUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = stocks.firstIndex(where: { $0.id == id }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        view?.updateCell(for: indexPath)
    }
}


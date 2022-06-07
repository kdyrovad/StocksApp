//
//  DetailPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 31.05.2022.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}

protocol DetailPresenterProtocol {
    var view: DetailViewProtocol? { get set }
    var price: String? { get }
    var bigTitle: String? { get }
    var littleTitle: String? { get }
    var change: String? { get }
    var favoriteButtonIsClicked: Bool { get }
    
    func loadView()
    func favoriteButtonTapped()
}

final class DetailPresenter: DetailPresenterProtocol {
    
    private let service: StocksServiceProtocol
    private let model: StockModelProtocol
    
    init(service: StocksServiceProtocol, model: StockModelProtocol) {
        self.service = service
        self.model = model
    }
    
    weak var view: DetailViewProtocol?
    
    func loadView() {
        view?.updateView(withLoader: true)
        service.getChart { [weak self] result in
            self?.view?.updateView(withLoader: false)
            switch result {
            case .success(_):
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    var price: String? {
        return model.price
    }
        
    var bigTitle: String? {
        return model.name
    }
    
    var littleTitle: String? {
        return model.symbol
    }
        
    var change: String? {
        return model.change
    }
    
    var favoriteButtonIsClicked: Bool {
        return model.isFav
    }
    
    func favoriteButtonTapped() {
        model.setFavorite()
    }
}


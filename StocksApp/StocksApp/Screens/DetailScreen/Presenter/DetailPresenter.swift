//
//  DetailPresenter.swift
//  StocksApp
//
//  Created by Dilyara on 31.05.2022.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func updateView(with model: ChartsModel)
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}

protocol DetailPresenterProtocol {
    var view: DetailViewProtocol? { get set }
    var favoriteButtonIsClicked: Bool { get }
    var price: String? { get }
    var bigTitle: String? { get }
    var littleTitle: String? { get }
    var change: String? { get }
    
    func loadView()
    func favoriteButtonTapped()
}

final class DetailPresenter: DetailPresenterProtocol {
    
    private let model: StockModelProtocol
    
    var favoriteButtonIsClicked: Bool {
        return model.isFav
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
    
    private let service: ChartsServiceProtocol
    
    init(service: ChartsServiceProtocol, model: StockModelProtocol) {
        self.service = service
        self.model = model
    }
    
    weak var view: DetailViewProtocol?
    
    func favoriteButtonTapped() {
        model.setFavorite()
    }
    
    func loadView() {
        view?.updateView(withLoader: true)
        
        service.getCharts(id: model.id) { [weak self] result in
            self?.view?.updateView(withLoader: false)
            switch result {
            case .success(let charts):
                self?.view?.updateView(with: .build(from: charts))
                print("RESULT: \(charts.prices)")
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
        
//        service.getChart { [weak self] result in
//            self?.view?.updateView(withLoader: false)
//            switch result {
//            case .success(_):
//                self?.view?.updateView()
//            case .failure(let error):
//                self?.view?.updateView(withError: error.localizedDescription)
//            }
//        }
    }
}



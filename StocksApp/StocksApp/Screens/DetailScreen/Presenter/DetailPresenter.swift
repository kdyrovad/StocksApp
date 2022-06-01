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
    
    func loadView()
}

final class DetailPresenter: DetailPresenterProtocol {
    
    private let service: StocksServiceProtocol
    
    //private var stocks: [StockModelProtocol] = []
    
    init(service: StocksServiceProtocol) {
        self.service = service
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
}


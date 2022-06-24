//
//  Main.swift
//  StocksApp
//
//  Created by Dilyara on 30.05.2022.
//

import Foundation
import UIKit

final class Main {
    private init() {}
    
    private lazy var network: NetworkService = {
        Network()
    }()
    
    let favoritesService: FavoritesServiceProtocol = FavoritesLocalService()
    private lazy var chartsService: ChartsServiceProtocol = ChartsService(network: network)
    
    static let shared: Main = .init()
    
    func networkService() -> NetworkService {
        network
    }
    
    func stocksService() -> StocksServiceProtocol {
        StocksService(client: network)
    }
    
    func stocksVC() -> UIViewController {
        let presneter = StocksPresenter(service: stocksService())
        let view = StocksViewController(presenter: presneter)
        presneter.view = view
        
        return view
    }
    
    func secondVC() -> UIViewController {
        let presenter = FavoritesPresenter(service: stocksService())
        let view = FavoritesVC(presenter: presenter)
        presenter.view = view as StocksViewProtocol
        
        return view
    }
    
    func thirdVC() -> UIViewController {
        let presneter = SearchPresenter(service: stocksService())
        let view = SearchVC(presenter: presneter)
        presneter.view = view
        
        return view
    }
    
    func tabbarController() -> UIViewController {
        let tabbar = UITabBarController()
        
        let stocksVC = UINavigationController(rootViewController: self.stocksVC())
        stocksVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "diagram"), tag: 0)
        
        let secondVC = UINavigationController(rootViewController: self.secondVC())
        secondVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "fav"), tag: 1)
        
        let thirdVC = UINavigationController(rootViewController: self.thirdVC())
        thirdVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search"), tag: 2)
        
        tabbar.viewControllers = [stocksVC, secondVC, thirdVC]
        
        return tabbar
    }
    
    func detailVC(for model: StockModelProtocol) -> UIViewController {
        let presenter = DetailPresenter(service: chartsService, model: model)
        let detailVC = DetailVC(presenter: presenter)
        presenter.view = detailVC
        
        return detailVC
    }
}

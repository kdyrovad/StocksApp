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
        FavoritesVC()
    }
    
    func thirdVC() -> UIViewController {
        UIViewController()
    }
    
    func tabbarController() -> UIViewController {
        let tabbar = UITabBarController()
        
        let stocksVC = UINavigationController(rootViewController: self.stocksVC())
        stocksVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "diagram"), tag: 0)
        stocksVC.tabBarItem.title = ""
        
        let secondVC = secondVC()
        secondVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "fav"), tag: 1)
        
        let thirdVC = thirdVC()
        thirdVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search"), tag: 2)
        
        tabbar.viewControllers = [stocksVC, secondVC, thirdVC]
        
        return tabbar
    }
    
    func detailVC(for model: StockModelProtocol) -> UIViewController {
        let presenter = DetailPresenter(service: stocksService(), model: model)
        let detailVC = DetailVC(presenter: presenter)
        presenter.view = detailVC
            
        return detailVC
    }
}


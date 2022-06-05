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
    
    static let shared: Main = .init()
//    }
    
    func secondVC() -> UIViewController {
        UIViewController()
    }
    
    func thirdVC() -> UIViewController {
        UIViewController()
    }
    
    func tabbarController() -> UIViewController {
        let tabbar = UITabBarController()
        
        let stocksVC = UINavigationController(rootViewController: StocksViewController())
        stocksVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "diagram"), tag: 0)
        
        let secondVC = secondVC()
        secondVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "fav"), tag: 2)
        
        let thirdVC = thirdVC()
        thirdVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search"), tag: 2)
        
        tabbar.viewControllers = [stocksVC, secondVC, thirdVC]
        
        return tabbar
    }
}


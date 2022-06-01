//
//  AppDelegate.swift
//  StocksApp
//
//  Created by Dilyara on 29.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Main.shared.tabbarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func stocksVC() -> UIViewController {
        let client = Network()
        let service = StocksService(client: client)
        let presenter = StocksPresenter(service: service)
        let view = StocksViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}

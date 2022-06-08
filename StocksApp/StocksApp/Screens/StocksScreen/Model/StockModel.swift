//
//  StockModel.swift
//  StocksApp
//
//  Created by Dilyara on 31.05.2022.
//

import Foundation
import UIKit

protocol StockModelProtocol {
    var id: String { get }
    var name: String { get }
    var iconURL: String { get }
    var symbol: String { get }
    var price: String { get }
    var change: String { get }
    var changeColor: UIColor { get }
    
    var isFav: Bool { get set }
    
    func setFavorite()
}

final class StockModel: StockModelProtocol {
    
    private let stock: Stock
    private let favoritesService: FavoritesServiceProtocol
    
    init(stock: Stock) {
        self.stock = stock
        favoritesService = Main.shared.favoritesService
        isFav = favoritesService.isFavorite(for: id)
    }
        
    var id: String {
        stock.id
    }
    
    var name: String {
        stock.name
    }
    
    var iconURL: String {
        stock.image
    }
    
    var symbol: String {
        stock.symbol
    }
    
    var price: String {
        "\(String(format: "%.2f", stock.price)) ₽"
    }
    
    var change: String {
        String(stock.change).range(of: "-") != nil ? "\(String(format: "%.2f", stock.change)) ₽ (\(String(format: "%.2f", stock.changePercentage)))%" : "+\(String(format: "%.2f", stock.change)) ₽ (\(String(format: "%.2f", stock.changePercentage)))%"
    }
    
    var changeColor: UIColor {
        stock.change >= 0 ? UIColor(red: 36/255, green: 178/255, blue: 93/255, alpha: 1) : UIColor(red: 178/255, green: 36/255, blue: 93/255, alpha: 1)
    }
    
    var isFav: Bool = false
    
    func setFavorite() {
        isFav.toggle()
        
        if isFav {
            favoritesService.save(id: id)
        } else {
            favoritesService.delete(id: id)
        }
    }
}

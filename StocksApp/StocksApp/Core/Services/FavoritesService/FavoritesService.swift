//
//  FavoritesService.swift
//  StocksApp
//
//  Created by Dilyara on 01.06.2022.
//

import Foundation

protocol FavoritesServiceProtocol {
    func save(id: String)
    func delete(id: String)
    func isFavorite(for id: String) -> Bool
}

final class FavoritesService: FavoritesServiceProtocol {
    private let key = "favorite_key"
    private lazy var favoritesIds: [String] = {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
              let ids = try? JSONDecoder().decode([String].self, from: data)
        else {
            return []
        }
        
        return ids
    }()
    
    func save(id: String) {
        favoritesIds.append(id)
        updateRepo()
    }
    
    func delete(id: String) {
        if let index = favoritesIds.firstIndex(where: { $0 == id }) {
            favoritesIds.remove(at: index)
            updateRepo()
        }
    }
    
    func isFavorite(for id: String) -> Bool {
        favoritesIds.contains(id)
    }
    
    private func updateRepo() {
        guard let data = try? JSONEncoder().encode(favoritesIds) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: key)
        print("updated")
    }
}

final class FavoritesLocalService: FavoritesServiceProtocol {
    private lazy var path: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Favorites")
    }()
    private lazy var favoritesIds: [String] = {
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("FileManager ReadError - ", error.localizedDescription)
        }
        return []
    }()
    
    func save(id: String) {
        favoritesIds.append(id)
        updateRepo(with: id)
        print("\(id) WAS SAVED")
    }
    
    func delete(id: String) {
        if let index = favoritesIds.firstIndex(where: { $0 == id }) {
            favoritesIds.remove(at: index)
            updateRepo(with: id)
            print("\(id) WAS DELETED")
        }
    }
    
    func isFavorite(for id: String) -> Bool {
        favoritesIds.contains(id)
    }
    
    private func updateRepo(with id: String) {
        do {
            let data = try JSONEncoder().encode(favoritesIds)
            try data.write(to: path)
            NotificationCenter.default.post(name: NSNotification.Name("Update.Favorite.Stocks"),
                                            object: nil,
                                            userInfo: ["id": id])
        } catch {
            print("FileManager WriteError - ", error.localizedDescription)
        }
    }
}

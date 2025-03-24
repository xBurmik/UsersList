//
//  FavoriteService.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import Foundation
import RealmSwift

class FavoritesService {
    private var realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func getFavorites() -> [FavoriteUser] {
        return Array(realm.objects(FavoriteUser.self))
    }
    
    func isFavorite(userId: Int) -> Bool {
        return realm.object(ofType: FavoriteUser.self, forPrimaryKey: userId) != nil
    }
    
    func toggleFavorite(user: User) {
        if isFavorite(userId: user.id) {
            removeFromFavorites(userId: user.id)
        } else {
            addToFavorites(user: user)
        }
    }
    
    private func addToFavorites(user: User) {
        let favoriteUser = FavoriteUser(from: user)
        
        do {
            try realm.write {
                realm.add(favoriteUser, update: .modified)
            }
        } catch {
            print("Error adding to favorites: \(error)")
        }
    }
    
    private func removeFromFavorites(userId: Int) {
        guard let favoriteUser = realm.object(ofType: FavoriteUser.self, forPrimaryKey: userId) else {
            return
        }
        
        do {
            try realm.write {
                realm.delete(favoriteUser)
            }
        } catch {
            print("Error removing from favorites: \(error)")
        }
    }
}

//
//  FavoritesViewModel.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var support: Support?
    
    private let apiService = APIService()
    private let favoritesService = FavoritesService()
    
    func refreshSupport() async {
        do {
            let response = try await apiService.getUsers(page: 0)
            support = response.support
        } catch { print(error.localizedDescription) }
    }
    
    func loadFavorites() {
        let favoriteUsers = favoritesService.getFavorites()
        users = favoriteUsers.map { $0.toUser() }
    }
    
    func toggleFavorites(user: User) {
        favoritesService.toggleFavorite(user: user)
        loadFavorites()
    }
}

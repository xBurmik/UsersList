//
//  UserListViewModel.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import SwiftUICore

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var supportText: Support?
    @Published var error: (hasError: Bool, body: APIError?) = (false, nil)
    @Published var currentPage = 1
    @Published var isLoading = false
    @Published var hasMorePages = true
    
    private let apiService = APIService()
    private let favoritesService = FavoritesService()
}

//MARK: API methods
extension UserListViewModel {
    func loadInitialData() async {
        currentPage = 1
        users = []
        hasMorePages = true
        await loadUsers()
    }
    
    func loadNextPageIfNeeded(user: User) async {
        guard !isLoading, hasMorePages else { return }
        
        let thresholdIndex = users.index(users.endIndex, offsetBy: -3)
        if users.firstIndex(where: { $0.id == user.id }) == thresholdIndex {
            currentPage += 1
            await loadUsers()
        }
    }
    
    func loadUsers() async {
        if currentPage == 1 { users = [] }
        isLoading = true
        error = (false,nil)
        
        do {
            let response = try await apiService.getUsers(page: currentPage)
            withAnimation { users.append(contentsOf: response.data) }
            hasMorePages = currentPage < response.totalPages
            isLoading = false
            supportText = response.support
        } catch let apiError as APIError {
            error = (true,apiError)
            isLoading = false
        } catch {
            self.error = (true, APIError.unknown(error))
            isLoading = false
        }
    }
}

//MARK: Favorites user Methods
extension UserListViewModel {
    func toggleFavorite(user: User) {
        favoritesService.toggleFavorite(user: user)
        objectWillChange.send()
    }
    
    func isFavorite(userId: Int) -> Bool {
        return favoritesService.isFavorite(userId: userId)
    }
}


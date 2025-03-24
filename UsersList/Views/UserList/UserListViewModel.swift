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
    @Published var error: (hasError: Bool, body: APIError?) = (false, nil)
    @Published var listEnded = false
    @Published var currentPage = 1
    
    private let apiService = APIService()
    
    func loadInitialData() async {
        currentPage = 1
        listEnded = false
        withAnimation { users = [] }
        await loadUsers()
    }
    
    func loadUsers() async {
        if currentPage == 1 { users = [] }
        error = (false,nil)
        
        do {
            let response = try await apiService.getUsers(page: currentPage)
            if response.data.isEmpty {
                listEnded = true
            } else {
                withAnimation { users.append(contentsOf: response.data) }
            }
        } catch let apiError as APIError {
            error = (true,apiError)
        } catch {
            self.error = (true, APIError.unknown(error))
        }
    }
    
}

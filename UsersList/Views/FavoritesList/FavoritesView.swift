//
//  FavoritesView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: FavoritesViewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.users.isEmpty {
                    VStack {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No favorite users")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: UserDetailView(user: user, support: viewModel.support, isFavorite: true, onToggleFavorite: {
                                viewModel.toggleFavorites(user: user)
                            })) {
                                UserRowView(
                                    user: user,
                                    isFavorite: true,
                                    onToggleFavorite: {
                                        viewModel.toggleFavorites(user: user)
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            viewModel.loadFavorites()
            Task { await viewModel.refreshSupport() }
        }
    }
}

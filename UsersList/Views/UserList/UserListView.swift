//
//  UserListView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    @State private var showingError = false
    @State private var isRefreshing = false
    
    init() {
        self._viewModel = StateObject(wrappedValue: UserListViewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user,
                                                                   support: viewModel.supportText,
                                                                   isFavorite: viewModel.isFavorite(userId: user.id),
                                                                   onToggleFavorite: { viewModel.toggleFavorite(user: user) }
                                                                  )) {
                            UserRowView(
                                user: user,
                                isFavorite: viewModel.isFavorite(userId: user.id),
                                onToggleFavorite: { viewModel.toggleFavorite(user: user) }
                            )
                        }
                                                                  .onAppear {
                                                                      Task { await viewModel.loadNextPageIfNeeded(user: user) }
                                                                  }
                    }
                    if !viewModel.hasMorePages {
                        Text("More user in future")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if viewModel.error.body == .connectionError {
                        Text("Check your internet connection and refresh screen")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        HStack {
                            Spacer()
                            ProgressView("Loading users...")
                                .foregroundStyle(.secondary)
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                            Spacer()
                        }
                    }
                }
                .refreshable {
                    isRefreshing = true
                    Task {
                        await viewModel.loadInitialData()
                        isRefreshing = false
                    }
                }
            }
            .navigationTitle("Users")
            
            .alert(isPresented: $viewModel.error.hasError) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error.body?.message ?? String(localized: "Unknown error")),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .task { await viewModel.loadInitialData() }
    }
    
}

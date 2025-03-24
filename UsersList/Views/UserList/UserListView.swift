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
                                                                   isFavorite: false, // TODO: handle favorite
                                                                   onToggleFavorite: { } // TODO: handle favorite
                                                                  )) {
                            UserRowView(
                                user: user,
                                isFavorite: false, // TODO: handle favorite
                                onToggleFavorite: { } // TODO: handle favorite
                            )
                        }
                    }
                    if viewModel.listEnded {
                        Text("More user in future")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if viewModel.error.body == .connectionError {
                        Text("Check your internet connection and refresh screen")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }else {
                        HStack {
                            Spacer()
                            ProgressView("Loading users...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                            Spacer()
                        }
                        .onAppear {
                            viewModel.currentPage += 1
                            Task { await viewModel.loadUsers() }
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

//
//  ContentView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: ScreenState = .usersList
    
    var body: some View {
        TabView(selection: $selection) {
            UserListView()
                .tabItem {
                    Label("Users", systemImage: "person.3")
                }
                .tag(ScreenState.usersList)
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                .tag(ScreenState.favoritesList)
        }
    }
    
    enum ScreenState {
        case usersList
        case favoritesList
    }
}

#Preview {
    ContentView()
}

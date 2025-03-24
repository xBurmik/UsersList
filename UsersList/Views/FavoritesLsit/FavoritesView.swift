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
        Text("Hello, Favorites!")
    }
}

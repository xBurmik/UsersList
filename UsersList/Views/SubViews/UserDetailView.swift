//
//  UserDetailView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//


import SwiftUI

struct UserDetailView: View {
    let user: User
    let isFavorite: Bool //TODO: handle favorite
    let onToggleFavorite: () -> Void // TODO: handle favorite
    
    var body: some View {
        Text("Hello, \(user.fullName)")
        .navigationTitle(user.fullName)
    }
}

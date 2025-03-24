//
//  UserListView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: UserListViewModel())
    }
    
    var body: some View {
        Text("Hello, Users!")
    }
    
}

//
//  UserDetailView.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//


import SwiftUI

struct UserDetailView: View {
    let user: User
    let support: Support?
    let isFavorite: Bool
    let onToggleFavorite: () -> Void 
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.avatar)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 150)
                .padding(.top, 20)

                Text(user.fullName)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Divider()
                
                if let support = support {
                    Button(action: {
                        if let url = URL(string: support.url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(support.text)
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .padding(.bottom, 5)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarItems(trailing:
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
            }
        )
    }
}

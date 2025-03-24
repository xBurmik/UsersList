//
//  RealmModel.swift
//  UsersList
//
//  Created by Alexey Burmistrov on 24.03.2025.
//

import Foundation
import RealmSwift

final class FavoriteUser: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var email: String = ""
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var avatar: String = ""
    
    var fullName: String { return "\(firstName) \(lastName)" }
    
    convenience init(from user: User) {
        self.init()
        self.id = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.avatar = user.avatar
    }
    
    func toUser() -> User {
        return User(id: id, email: email, firstName: firstName, lastName: lastName, avatar: avatar)
    }
}

//
//  Users.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation

struct MUser: Hashable, Decodable {

    var email: String
    var description: String
    var sex: String
    var username: String
    var avatarStringURL: String
    var id: String

    var representation: [String: Any] {
        var dict = ["uid": id]
        dict["email"] = self.email
        dict["username"] = self.username
        dict["description"] = self.description
        dict["sex"] = self.sex
        dict["avatarStringURL"] = self.avatarStringURL
        return dict
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }

    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
            let lowercasedFilter = filter.lowercased()
            return username.lowercased().contains(lowercasedFilter)
    }
}

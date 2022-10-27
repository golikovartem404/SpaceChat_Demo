//
//  Users.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import FirebaseFirestore

struct MUser: Hashable, Decodable {

    var email: String
    var description: String
    var sex: String
    var username: String
    var avatarStringURL: String
    var id: String

    init(email: String, description: String, sex: String, username: String, avatarStringURL: String, id: String) {
        self.email = email
        self.description = description
        self.sex = sex
        self.username = username
        self.avatarStringURL = avatarStringURL
        self.id = id
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let description = data["description"] as? String,
        let sex = data["sex"] as? String,
        let id = data["uid"] as? String,
        let avatarStringURL = data["avatarStringURL"] as? String else { return nil }

        self.email = email
        self.description = description
        self.sex = sex
        self.username = username
        self.avatarStringURL = avatarStringURL
        self.id = id
    }

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

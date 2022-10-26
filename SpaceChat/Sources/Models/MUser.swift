//
//  Users.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation

struct MUser: Hashable, Decodable {

    var username: String
    var avatarStringURL: String
    var id: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
}

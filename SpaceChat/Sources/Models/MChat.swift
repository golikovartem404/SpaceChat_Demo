//
//  MChat.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation

struct MChat: Hashable, Decodable {

    var username: String
    var lastMessage: String
    var userImageString: String
    var id: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}

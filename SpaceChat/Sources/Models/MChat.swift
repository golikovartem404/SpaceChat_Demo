//
//  MChat.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation

struct MChat: Hashable, Decodable {

    var friendUsername: String
    var lastMessageContent: String
    var friendAvatarStringURL: String
    var friendID: String

    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["lastMessageContent"] = lastMessageContent
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["friendID"] =  friendID
        return rep
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendID == rhs.friendID
    }
}

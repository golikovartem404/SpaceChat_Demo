//
//  MChat.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import FirebaseFirestore

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

    init(friendUsername: String, lastMessageContent: String, friendAvatarStringURL: String, friendID: String) {
        self.friendUsername = friendUsername
        self.lastMessageContent = lastMessageContent
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendID = friendID
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
        let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
        let lastMessageContent = data["lastMessageContent"] as? String,
        let friendID = data["friendID"] as? String else { return nil }

        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
        self.friendID = friendID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }

    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendID == rhs.friendID
    }
}

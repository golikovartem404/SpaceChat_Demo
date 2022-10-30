//
//  MMessage.swift
//  SpaceChat
//
//  Created by User on 30.10.2022.
//

import UIKit

struct MMessage: Hashable {

    let content: String
    let senderID: String
    let senderUsername: String
    let sendDate: Date
    let messageID: String?

    init(user: MUser, content: String) {
        self.content = content
        senderID = user.id
        senderUsername = user.username
        sendDate = Date()
        messageID = nil
    }

    var representation: [String: Any] {
        var rep: [String: Any] = [
            "created": sendDate,
            "senderID": senderID,
            "senderUsername": senderUsername,
            "content": content
        ]
        return rep
    }

}

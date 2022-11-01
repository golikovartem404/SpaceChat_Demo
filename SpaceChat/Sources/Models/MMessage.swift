//
//  MMessage.swift
//  SpaceChat
//
//  Created by User on 30.10.2022.
//

import UIKit
import FirebaseFirestore

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

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sendDate = data["created"] as? Timestamp else { return nil}
        guard let senderID = data["senderID"] as? String else { return nil}
        guard let senderUsername = data["senderUsername"] as? String else { return nil}
        guard let content = data["content"] as? String else { return nil}

        self.messageID = document.documentID
        self.sendDate = sendDate.dateValue()
        self.senderID = senderID
        self.senderUsername = senderUsername
        self.content = content
    }

    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sendDate,
            "senderID": senderID,
            "senderUsername": senderUsername,
            "content": content
        ]
        return rep
    }

}

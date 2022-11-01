//
//  FirestoreService.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirestoreService {

    static let shared = FirestoreService()

    let database = Firestore.firestore()

    private var usersRef: CollectionReference {
        return database.collection("users")
    }

    var currentUser: MUser!
    private var waitingChatsRefrence: CollectionReference {
        return database.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    private var activeChatsRefrence: CollectionReference {
        return database.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }


    func getUserData(user: User, completion: @escaping(Result<MUser, Error>) -> ()) {
        let documentReference = usersRef.document(user.uid)
        documentReference.getDocument { document, error in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(ProfileSaveErrors.cannotUnwrapToMUser))
                    return
                }
                self.currentUser = mUser
                completion(.success(mUser))
            } else {
                completion(.failure(ProfileSaveErrors.cannotGetUserInfo))
            }
        }
    }

    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> ()) {
        guard ValidationService.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(ProfileSaveErrors.notFilled))
            return
        }
        guard let avatarImage = avatarImage, avatarImage != UIImage(named: "photoIcon") else {
            completion(.failure(ProfileSaveErrors.photoNotExist))
            return
        }
        var mUser = MUser(email: email,
                          description: description ?? "",
                          sex: sex ?? "",
                          username: username ?? "",
                          avatarStringURL: "not exist",
                          id: id)
        StorageService.shared.uploadAvatarImage(image: avatarImage) { result in
            switch result {
            case .success(let url):
                mUser.avatarStringURL = url.absoluteString
                self.usersRef.document(mUser.id).setData(mUser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(mUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                print("Problem during save profile data")
            }
        }
    }

    func createWaitingChat(message: String, reciever: MUser, completion: @escaping(Result<Void, Error>) -> ()) {

        let reference = database.collection(["users", reciever.id, "waitingChats"].joined(separator: "/"))
        let messageReference = reference.document(self.currentUser.id).collection("messages")

        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                         lastMessageContent: message.content,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         friendID: currentUser.id)
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
//            completion(.success(Void()))
            messageReference.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }

    func deleteWaitingChat(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        waitingChatsRefrence.document(chat.friendID).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            self.deleteMessages(chat: chat, completion: completion)
        }
    }

    func deleteMessages(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        let reference = waitingChatsRefrence.document(chat.friendID).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.messageID else { return }
                    let messageReference = reference.document(documentID)
                    messageReference.delete() { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getWaitingChatMessages(chat: MChat, completion: @escaping(Result<[MMessage], Error>) -> ()) {
        let reference = waitingChatsRefrence.document(chat.friendID).collection("messages")
        var messages = [MMessage]()
        reference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in snapshot!.documents {
                guard let message = MMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }

    func changeChatToActive(chat: MChat, completion: @escaping(Result<Void, Error>) -> ()) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping(Result<Void, Error>) -> ()) {
        let messageReference = activeChatsRefrence.document(chat.friendID).collection("messages")
        activeChatsRefrence.document(chat.friendID).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messageReference.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}

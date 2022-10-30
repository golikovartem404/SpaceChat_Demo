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
}

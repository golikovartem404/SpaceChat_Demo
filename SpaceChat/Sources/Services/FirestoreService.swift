//
//  FirestoreService.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreService {

    static let shared = FirestoreService()

    let database = Firestore.firestore()

    private var usersRef: CollectionReference {
        return database.collection("users")
    }

    func getUserData(user: User, completion: @escaping(Result<MUser, Error>) -> ()) {
        let documentReference = usersRef.document(user.uid)
        documentReference.getDocument { document, error in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(ProfileSaveErrors.cannotUnwrapToMUser))
                    return
                }
                completion(.success(mUser))
            } else {
                completion(.failure(ProfileSaveErrors.cannotGetUserInfo))
            }
        }
    }

    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> ()) {
        guard ValidationService.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(ProfileSaveErrors.notFilled))
            return
        }
        let mUser = MUser(email: email,
                          description: description ?? "",
                          sex: sex ?? "",
                          username: username ?? "",
                          avatarStringURL: "not exist",
                          id: id)
        self.usersRef.document(mUser.id).setData(mUser.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mUser))
            }
        }
    }
}

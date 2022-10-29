//
//  ListenerService.swift
//  SpaceChat
//
//  Created by User on 29.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {

    static let shared = ListenerService()
    private let database = Firestore.firestore()
    private var usersReference: CollectionReference {
        return database.collection("users")
    }
    private var currentUserID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    func usersObserve(users: [MUser], completion: @escaping(Result<[MUser], Error>) -> ()) -> ListenerRegistration {
        var users = users
        let usersListener = usersReference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                print("Problem with snapshot")
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let mUser = MUser(document: difference.document) else {
                    return
                }
                switch difference.type {
                case .added:
                    guard !users.contains(mUser) else { return }
                    guard mUser.id != self.currentUserID else { return }
                    users.append(mUser)
                case .modified:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users[index] = mUser
                case .removed:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }

}

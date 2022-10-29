//
//  StorageService.swift
//  SpaceChat
//
//  Created by User on 29.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {

    static let shared = StorageService()
    let storageRef = Storage.storage().reference()

    private var avatarsRef: StorageReference {
        storageRef.child("avatars")
    }

    private var currentUserID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    func uploadAvatarImage(image: UIImage, completion: @escaping(Result<URL, Error>) -> ()) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {
            print("Не удалось сжать изображение")
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        avatarsRef.child(currentUserID).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                print("Problems with metadata")
                return
            }
            self.avatarsRef.child(self.currentUserID).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    print("Problems with URL")
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }

}

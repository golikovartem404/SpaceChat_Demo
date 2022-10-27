//
//  AuthenticationService.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import GoogleSignIn

class AuthenticationService {

    static let shared = AuthenticationService()
    private let auth = Auth.auth()

    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> ()) {
        guard let email = email, let password = password else {
            completion(.failure(AuthErrors.notFilled))
            return
        }
        guard ValidationService.isSimpleEmail(email) else {
            completion(.failure(AuthErrors.wrongEmail))
            return
        }
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }

    func googleLogin(user: GIDGoogleUser?, error: Error?, completion: @escaping (Result<User, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
        }
        guard let auth = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken ?? "",
                                                       accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }

    func registration(withEmail email: String?, andPassword password: String?, andConfirmPassword confirmPassword: String?, completion: @escaping (Result<User, Error>) -> ()) {
        guard ValidationService.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthErrors.notFilled))
            return
        }
        guard password?.lowercased() == confirmPassword?.lowercased() else {
            completion(.failure(AuthErrors.passwordNotMatched))
            return
        }
        guard ValidationService.isSimpleEmail(email ?? "") else {
            completion(.failure(AuthErrors.wrongEmail))
            return
        }
        auth.createUser(withEmail: email ?? "", password: password ?? "") { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }

}

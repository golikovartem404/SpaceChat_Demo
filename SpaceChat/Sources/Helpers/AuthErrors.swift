//
//  AuthErrors.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import Foundation

enum AuthErrors {
    case notFilled
    case wrongEmail
    case passwordNotMatched
    case unknownError
    case serverError
}

extension AuthErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please fill all fields", comment: "")
        case .wrongEmail:
            return NSLocalizedString("Email is wrong", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Password not matched", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}

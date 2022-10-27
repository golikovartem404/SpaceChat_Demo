//
//  SaveProfileErrors.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import Foundation

enum ProfileSaveErrors {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMUser
}

extension ProfileSaveErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please fill all fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Please choose an avatar", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Unable get user data from Firestore", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Unable convert data from database", comment: "")
        }
    }
}

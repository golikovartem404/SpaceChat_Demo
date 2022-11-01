//
//  AlertDelegate.swift
//  SpaceChat
//
//  Created by User on 29.10.2022.
//

import Foundation

protocol ShowAlertDelegate: AnyObject {
    func showAlert(title: String, message: String)
}

//
//  SceneDelegate + Ext.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import UIKit

extension SceneDelegate {
    static var shared: SceneDelegate {
        return (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate)
    }
}

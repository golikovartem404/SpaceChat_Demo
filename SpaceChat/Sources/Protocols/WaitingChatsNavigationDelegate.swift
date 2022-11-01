//
//  WaitingChatsNavigationDelegate.swift
//  SpaceChat
//
//  Created by User on 01.11.2022.
//

import Foundation

protocol WaitingChatsNavigationDelegate: AnyObject {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}

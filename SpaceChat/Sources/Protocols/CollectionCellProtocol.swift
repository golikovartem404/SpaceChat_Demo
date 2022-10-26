//
//  CollectionCellProtocol.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure<U: Hashable>(with value: U)
}

//
//  UILabel + Ext.swift
//  SpaceChat
//
//  Created by User on 25.10.2022.
//

import Foundation
import UIKit

extension UILabel {

    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }

}

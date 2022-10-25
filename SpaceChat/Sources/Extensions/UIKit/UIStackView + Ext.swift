//
//  UIStackView + Ext.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

extension UIStackView {

    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init()
        self.axis = axis
        self.spacing = spacing
    }

}

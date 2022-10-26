//
//  UIView + Ext.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import Foundation
import UIKit

extension UIView {

    func applyGradient(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradient = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .gradientStartColor(), endColor: .gradientEndColor())
        if let gradientlayer = gradient.layer.sublayers?.first as? CAGradientLayer {
            gradientlayer.frame = self.bounds
            gradientlayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientlayer, at: 0)
        }
    }

}

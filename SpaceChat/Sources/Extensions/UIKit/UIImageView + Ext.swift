//
//  UIImageView + Ext.swift
//  SpaceChat
//
//  Created by User on 25.10.2022.
//

import Foundation
import UIKit

extension UIImageView {

    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }

}

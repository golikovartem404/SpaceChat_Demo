//
//  UIButton + Ext.swift
//  SpaceChat
//
//  Created by User on 25.10.2022.
//

import Foundation
import UIKit

extension UIButton {

    convenience init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont? = .avenir20(), isShadow: Bool = false, cornerRadius: CGFloat = 4) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }

    func customizedGoogleButton() {
        let googleLogo = UIImageView(image: UIImage(named: "googleIcon"), contentMode: .scaleAspectFit)
        self.addSubview(googleLogo)
        googleLogo.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.width.height.equalTo(35)
        }
    }

}

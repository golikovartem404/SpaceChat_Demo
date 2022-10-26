//
//  CustomTextField.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

class OneLineTextField: UITextField {

    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        self.font = font
        self.borderStyle = .none

        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        bottomView.backgroundColor = .textFieldBorder()

        self.addSubview(bottomView)

        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }

}

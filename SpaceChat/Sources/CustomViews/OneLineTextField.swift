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
        self.textColor = .black
        self.returnKeyType = .done

        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        bottomView.backgroundColor = .textFieldBorder()
        self.addSubview(bottomView)

        bottomView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(1)
        }
    }

}

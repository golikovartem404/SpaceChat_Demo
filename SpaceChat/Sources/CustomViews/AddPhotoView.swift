//
//  AddPhotoView.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

class AddPhotoView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photoIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .buttonBlack()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }

    private func setupHierarchy() {
        self.addSubview(imageView)
        self.addSubview(plusButton)
    }

    private func setupLayout() {

        imageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.height.width.equalTo(100)
        }

        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.width.height.equalTo(40)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.trailing.equalTo(plusButton.snp.trailing)
        }
    }
    
}

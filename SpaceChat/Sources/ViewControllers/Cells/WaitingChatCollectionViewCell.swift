//
//  WaitingChatCollectionViewCell.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class WaitingChatCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    static var identifier = "WaitingChatCollectionViewCell"

    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(chatImageView)
    }

    private func setupLayout() {
        chatImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }

    func configure(with value: MChat) {
        chatImageView.image = UIImage(named: value.userImageString)
    }
}

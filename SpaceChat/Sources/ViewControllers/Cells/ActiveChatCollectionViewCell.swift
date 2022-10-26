//
//  ActiveChatCollectionViewCell.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure(with value: MChat)
}

class ActiveChatCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    static var identifier = "ActiveChatCollectionViewCell"

    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    let friendName = UILabel(text: "Username", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "How are you?", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing,
                                    to: .bottomLeading,
                                    startColor: .gradientStartColor(),
                                    endColor: .gradientEndColor())

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        gradientView.backgroundColor = .brown
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(chatImageView)
        addSubview(friendName)
        addSubview(lastMessage)
        addSubview(gradientView)
    }

    private func setupLayout() {

        chatImageView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
            make.width.height.equalTo(78)
        }

        friendName.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(chatImageView.snp.trailing).offset(16)
            make.trailing.equalTo(gradientView.snp.leading).offset(-16)
        }

        lastMessage.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-12)
            make.leading.equalTo(chatImageView.snp.trailing).offset(16)
            make.trailing.equalTo(gradientView.snp.leading).offset(-16)
        }

        gradientView.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(10)
            make.height.equalTo(self)
        }
    }

    func configure(with value: MChat) {
        chatImageView.image = UIImage(named: value.userImageString)
        friendName.text = value.username
        lastMessage.text = value.lastMessage
    }

}

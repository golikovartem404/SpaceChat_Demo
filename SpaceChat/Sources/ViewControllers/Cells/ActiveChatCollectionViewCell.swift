//
//  ActiveChatCollectionViewCell.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class ActiveChatCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    static var identifier = "ActiveChatCollectionViewCell"

    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let friendName = UILabel(
        text: "Username",
        font: .laoSangamMN20()
    )
    let lastMessage = UILabel(
        text: "How are you?",
        font: .laoSangamMN18()
    )
    let gradientView = GradientView(
        from: .topTrailing,
        to: .bottomLeading,
        startColor: .gradientStartColor(),
        endColor: .gradientEndColor()
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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

    func configure<U>(with value: U) where U : Hashable {
        guard let chat: MChat = value as? MChat else { return }
        chatImageView.image = UIImage(named: chat.userImageString)
        friendName.text = chat.username
        lastMessage.text = chat.lastMessage
    }

}

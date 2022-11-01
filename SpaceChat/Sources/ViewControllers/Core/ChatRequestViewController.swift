//
//  ChatRequestViewController.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {

    private var chat: MChat
    weak var delegate: WaitingChatsNavigationDelegate?

    let containerView = UIView()
    let imageView = UIImageView(
        image: UIImage(named: "human7"),
        contentMode: .scaleAspectFill
    )
    let nameLabel = UILabel(
        text: "Justin Kingsley",
        font: .systemFont(ofSize: 20, weight: .light)
    )
    let aboutMeLabel = UILabel(
        text: "You have the opportunity to start new chat",
        font: .systemFont(ofSize: 16, weight: .light)
    )
    let acceptButton = UIButton(
        title: "ACCEPT",
        titleColor: .white,
        backgroundColor: .black,
        font: .laoSangamMN20(),
        isShadow: false,
        cornerRadius: 10
    )
    let denyButton = UIButton(
        title: "DENY",
        titleColor: .denyButtonColor(),
        backgroundColor: .mainWhite(),
        font: .laoSangamMN20(),
        isShadow: false,
        cornerRadius: 10
    )
    let buttonsStackView = UIStackView(
        axis: .horizontal,
        spacing: 7
    )

    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        setupHierarchy()
        setupLayout()
        customizeElements()
        setupActionsForButtons()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradient(cornerRadius: 10)
    }

    private func setupHierarchy() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        buttonsStackView.addArrangedSubview(acceptButton)
        buttonsStackView.addArrangedSubview(denyButton)
        containerView.addSubview(buttonsStackView)
    }

    private func setupLayout() {

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(containerView.snp.top).offset(30)
        }

        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(206)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(30)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
        }

        aboutMeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(aboutMeLabel.snp.bottom).offset(22)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
            make.height.equalTo(56)
        }
    }

    private func customizeElements() {
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = UIColor.denyButtonColor().cgColor
        buttonsStackView.distribution = .fillEqually
    }

    private func setupActionsForButtons() {
        acceptButton.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonPressed), for: .touchUpInside)
    }

}

extension ChatRequestViewController {

    @objc private func denyButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }

    @objc private func acceptButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate?.changeToActive(chat: self.chat)
        }
    }
}

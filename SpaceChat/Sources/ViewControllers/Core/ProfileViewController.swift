//
//  ProfileViewController.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    private let user: MUser?
    weak var delegate: ShowAlertDelegate?

    let containerView = UIView()
    let imageView = UIImageView(
        image: UIImage(named: "human5"),
        contentMode: .scaleAspectFill
    )
    let nameLabel = UILabel(
        text: "Amy Lee",
        font: .systemFont(ofSize: 20, weight: .light)
    )
    let aboutMeLabel = UILabel(
        text: "Very love cats and dogs",
        font: .systemFont(ofSize: 16, weight: .light)
    )
    let myTextField = ProfileTextField()

    init(user: MUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
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
    }

    private func setupHierarchy() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(myTextField)
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
            make.top.equalTo(containerView).offset(35)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
        }

        aboutMeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
        }

        myTextField.snp.makeConstraints { make in
            make.top.equalTo(aboutMeLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(24)
            make.trailing.equalTo(containerView).offset(-24)
            make.height.equalTo(48)
        }
    }

    private func customizeElements() {
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }

    @objc private func sendMessage() {
        guard let message = myTextField.text, message != "" else { return }
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, reciever: self.user!) { result in
                switch result {
                case .success():
                    if let user = self.user {
                        self.delegate?.showAlert(title: "Success", message: "Your message to \(user.username) is send!")
                    }
                case .failure(let error):
                    self.delegate?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

}

//
//  ProfileViewController.swift
//  SpaceChat
//
//  Created by User on 27.10.2022.
//

import UIKit

class ProfileViewController: UIViewController {

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
        print("Send")
    }

}

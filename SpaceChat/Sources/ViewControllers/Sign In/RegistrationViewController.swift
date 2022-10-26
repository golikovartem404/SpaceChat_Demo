//
//  RegistrationViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class RegistrationViewController: UIViewController {

    let addPhotoView = AddPhotoView()

    let setupLabel = UILabel(text: "Set up profile", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")

    let fullNameTextField = OneLineTextField()
    let aboutMeTextField = OneLineTextField()

    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")

    let goToChatsButton = UIButton(title: "Go to chats", titleColor: .white, backgroundColor: .buttonBlack())

    let fullNameStack = UIStackView(axis: .vertical, spacing: 0)
    let aboutMeStack = UIStackView(axis: .vertical, spacing: 0)
    let sexSegmentedStack = UIStackView(axis: .vertical, spacing: 10)
    let mainStackView = UIStackView(axis: .vertical, spacing: 40)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(setupLabel)
        view.addSubview(addPhotoView)
        fullNameStack.addArrangedSubview(fullNameLabel)
        fullNameStack.addArrangedSubview(fullNameTextField)
        aboutMeStack.addArrangedSubview(aboutMeLabel)
        aboutMeStack.addArrangedSubview(aboutMeTextField)
        sexSegmentedStack.addArrangedSubview(sexLabel)
        sexSegmentedStack.addArrangedSubview(sexSegmentedControl)
        mainStackView.addArrangedSubview(fullNameStack)
        mainStackView.addArrangedSubview(aboutMeStack)
        mainStackView.addArrangedSubview(sexSegmentedStack)
        mainStackView.addArrangedSubview(goToChatsButton)
        view.addSubview(mainStackView)
    }

    private func setupLayout() {

        setupLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.35)
        }

        addPhotoView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.6)
        }

        goToChatsButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        mainStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.3)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }
    }
}

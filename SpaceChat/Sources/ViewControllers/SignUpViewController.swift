//
//  SignUpViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Hello", font: .avenir26())
    let emailLabel = UILabel(text: "Email")
    let emailTextField = OneLineTextField()
    let passwordLabel = UILabel(text: "Password")
    let passwordTextField = OneLineTextField()
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let confirmPasswordTextField = OneLineTextField()
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonBlack(), cornerRadius: 4)
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    let emailStack = UIStackView(axis: .vertical, spacing: 0)
    let passwordStack = UIStackView(axis: .vertical, spacing: 0)
    let confirmPasswordStack = UIStackView(axis: .vertical, spacing: 0)
    let mainStackView = UIStackView(axis: .vertical, spacing: 40)
    let bottomStackView = UIStackView(axis: .horizontal, spacing: 15)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(welcomeLabel)
        emailStack.addArrangedSubview(emailLabel)
        emailStack.addArrangedSubview(emailTextField)
        passwordStack.addArrangedSubview(passwordLabel)
        passwordStack.addArrangedSubview(passwordTextField)
        confirmPasswordStack.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordStack.addArrangedSubview(confirmPasswordTextField)
        mainStackView.addArrangedSubview(emailStack)
        mainStackView.addArrangedSubview(passwordStack)
        mainStackView.addArrangedSubview(confirmPasswordStack)
        mainStackView.addArrangedSubview(signUpButton)
        bottomStackView.addArrangedSubview(alreadyOnboardLabel)
        bottomStackView.addArrangedSubview(loginButton)
        view.addSubview(mainStackView)
        view.addSubview(bottomStackView)
    }

    private func setupLayout() {
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.35)
        }

        mainStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }

        bottomStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.7)
            make.leading.equalTo(view.snp.leading).offset(40)
        }
    }

}

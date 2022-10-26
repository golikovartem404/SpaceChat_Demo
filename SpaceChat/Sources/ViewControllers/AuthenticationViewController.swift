//
//  ViewController.swift
//  SpaceChat
//
//  Created by User on 25.10.2022.
//

import UIKit
import SnapKit

class AuthenticationViewController: UIViewController {

    // MARK: - Outlets

    let logoImageView = UIImageView(image: UIImage(named: "logo"), contentMode: .scaleAspectFit)

    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)

    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonBlack())

    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .buttonWhite(), isShadow: true)

    let mainStackView = UIStackView(axis: .vertical, spacing: 40)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierachy()
        setupLayout()
    }

    // MARK: - Setups

    func setupHierachy() {
        view.addSubview(logoImageView)
        let google = ButtonView(label: googleLabel, button: googleButton)
        let email = ButtonView(label: emailLabel, button: emailButton)
        let alreadyOnboard = ButtonView(label: alreadyOnboardLabel, button: loginButton)
        mainStackView.addArrangedSubview(google)
        mainStackView.addArrangedSubview(email)
        mainStackView.addArrangedSubview(alreadyOnboard)
        view.addSubview(mainStackView)
    }

    func setupLayout() {

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.45)
            make.width.equalTo(view).multipliedBy(0.85)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).multipliedBy(0.75)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }

    }
}

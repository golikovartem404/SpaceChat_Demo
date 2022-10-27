//
//  LoginViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class LoginViewController: UIViewController {

    weak var delegate: AuthenticationNavigtionDelegate?

    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAccountLabel = UILabel(text: "Need an account?")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonBlack())
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()

    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())

    let emailStack = UIStackView(axis: .vertical, spacing: 0)
    let passwordStack = UIStackView(axis: .vertical, spacing: 0)
    let mainStackView = UIStackView(axis: .vertical, spacing: 40)
    let bottomStackView = UIStackView(axis: .horizontal, spacing: 15)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.customizedGoogleButton()
        setupHierarchy()
        setupLayout()
        configureTargetsForButtons()
        customizeElements()
    }

    private func setupHierarchy() {
        view.addSubview(welcomeLabel)
        let loginWithView = ButtonView(label: loginWithLabel, button: googleButton)
        emailStack.addArrangedSubview(emailLabel)
        emailStack.addArrangedSubview(emailTextField)
        passwordStack.addArrangedSubview(passwordLabel)
        passwordStack.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(loginWithView)
        mainStackView.addArrangedSubview(orLabel)
        mainStackView.addArrangedSubview(emailStack)
        mainStackView.addArrangedSubview(passwordStack)
        mainStackView.addArrangedSubview(loginButton)
        view.addSubview(mainStackView)
        bottomStackView.addArrangedSubview(needAccountLabel)
        bottomStackView.addArrangedSubview(signUpButton)
        view.addSubview(bottomStackView)
    }

    private func setupLayout() {
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.35)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        mainStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.1)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }

        bottomStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.75)
            make.leading.equalTo(view.snp.leading).offset(40)
        }
    }

    private func customizeElements() {
        passwordTextField.isSecureTextEntry = true
    }

    private func configureTargetsForButtons() {
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Actions for Buttons Extension

extension LoginViewController {

    @objc private func loginButtonPressed() {
        AuthenticationService.shared.login(email: emailTextField.text,
                                           password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(withTitle: "Success", andMessage: "User is login") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let mUser):
                            self.present(MainTabBarController(), animated: true)
                        case .failure(let error):
                            self.present(RegistrationViewController(currentUser: user), animated: true)
                         }
                    }
                }
                print(user.email ?? "Not found")
            case .failure(let error):
                self.showAlert(withTitle: "Failure", andMessage: error.localizedDescription)
            }
        }
    }

    @objc private func signUpButtonPressed() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}

extension LoginViewController {

    func showAlert(withTitle title: String, andMessage message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }

}

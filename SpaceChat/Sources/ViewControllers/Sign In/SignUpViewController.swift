//
//  SignUpViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    weak var delegate: AuthenticationNavigtionDelegate?

    let welcomeLabel = UILabel(text: "Hello", font: .avenir26())
    let emailLabel = UILabel(text: "Email")
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordLabel = UILabel(text: "Password")
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .buttonBlack(), cornerRadius: 8)
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
        configureTargetsForButtons()
        customizeElements()
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

        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        mainStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }

        bottomStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.6)
            make.leading.equalTo(view.snp.leading).offset(40)
        }
    }

    private func customizeElements() {
        passwordTextField.isSecureTextEntry = true
    }

    private func configureTargetsForButtons() {
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Actions for Buttons Extension

extension SignUpViewController {

    @objc private func signUpButtonPressed() {
        AuthenticationService.shared.registration(withEmail: emailTextField.text,
                                                  andPassword: passwordTextField.text,
                                                  andConfirmPassword: confirmPasswordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(withTitle: "Success", andMessage: "User is register") {
                    self.present(RegistrationViewController(currentUser: user), animated: true)
                }
                print(user.email ?? "Not found")
            case .failure(let error):
                self.showAlert(withTitle: "Failure", andMessage: error.localizedDescription)
            }
        }
    }

    @objc private func loginButtonPressed() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}

extension SignUpViewController {

    func showAlert(withTitle title: String, andMessage message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}

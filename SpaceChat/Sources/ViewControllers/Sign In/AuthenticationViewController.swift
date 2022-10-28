//
//  ViewController.swift
//  SpaceChat
//
//  Created by User on 25.10.2022.
//

import UIKit
import SnapKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class AuthenticationViewController: UIViewController {

    // MARK: - Properties

    let signUpViewController = SignUpViewController()
    let loginViewController = LoginViewController()

    // MARK: - Outlets

    let logoImageView = UIImageView(
        image: UIImage(named: "logo2"),
        contentMode: .scaleAspectFit
    )

    let googleLabel = UILabel(
        text: "Get started with",
        font: .avenir20()
    )
    let emailLabel = UILabel(
        text: "Or sign up with",
        font: .avenir20()
    )
    let alreadyOnboardLabel = UILabel(
        text: "Already onboard?",
        font: .avenir20()
    )

    let googleButton = UIButton(
        title: "Google",
        titleColor: .black,
        backgroundColor: .white,
        isShadow: true
    )
    let emailButton = UIButton(
        title: "Email",
        titleColor: .white,
        backgroundColor: .buttonBlack()
    )
    let loginButton = UIButton(
        title: "Login",
        titleColor: .buttonRed(),
        backgroundColor: .mainWhite(),
        isShadow: true
    )

    let mainStackView = UIStackView(
        axis: .vertical,
        spacing: 40
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.customizedGoogleButton()
        setupHierachy()
        setupLayout()
        configureTargetsForButtons()
        loginViewController.delegate = self
        signUpViewController.delegate = self
    }

    // MARK: - Setups

    func setupHierachy() {
        view.addSubview(logoImageView)
        let google = ButtonView(
            label: googleLabel,
            button: googleButton
        )
        let email = ButtonView(
            label: emailLabel,
            button: emailButton
        )
        let alreadyOnboard = ButtonView(
            label: alreadyOnboardLabel,
            button: loginButton
        )
        mainStackView.addArrangedSubview(google)
        mainStackView.addArrangedSubview(email)
        mainStackView.addArrangedSubview(alreadyOnboard)
        view.addSubview(mainStackView)
    }

    func setupLayout() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.45)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).multipliedBy(0.75)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }
    }

    private func configureTargetsForButtons() {
        emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Actions For Buttons Extension

extension AuthenticationViewController {

    @objc private func emailButtonPressed() {
        present(signUpViewController, animated: true)
    }

    @objc private func loginButtonPressed() {
        present(loginViewController, animated: true)
    }

    @objc func googleButtonTapped() {
        guard
            let clientID = FirebaseApp.app()?.options.clientID
        else {
            return
        }
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self
        ) { user, error in
            AuthenticationService.shared.googleLogin(user: user,
                                                     error: error) { result in
                switch result {
                case .success(let user):
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let mUser):
                            self.showAlert(
                                withTitle: "Success",
                                andMessage: "Successfully login!"
                            ) {
                                let mainTabBar = MainTabBarController(currentUser: mUser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                self.present(mainTabBar, animated: true)
                            }
                        case .failure(_):
                            self.showAlert(
                                withTitle: "Success",
                                andMessage: "Please setup your profile!"
                            ) {
                                self.present(
                                    RegistrationViewController(currentUser: user),
                                    animated: true
                                )
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(
                        withTitle: "Error",
                        andMessage: error.localizedDescription
                    )
                }
            }
        }
    }

}

// MARK: - AuthenticationNavigtionDelegate Extension

extension AuthenticationViewController: AuthenticationNavigtionDelegate {
    func toLoginVC() {
        present(loginViewController, animated: true)
    }

    func toSignUpVC() {
        present(signUpViewController, animated: true)
    }
}

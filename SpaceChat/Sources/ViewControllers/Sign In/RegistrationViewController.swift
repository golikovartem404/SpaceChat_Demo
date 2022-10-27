//
//  RegistrationViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {

    private let currentUser: User

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

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        configureTargetsForButtons()
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

    private func configureTargetsForButtons() {
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonPressed), for: .touchUpInside)
    }
}

extension RegistrationViewController {

    @objc func goToChatsButtonPressed() {
        if let email = currentUser.email {
            FirestoreService.shared.saveProfileWith(
                id: currentUser.uid,
                email: email,
                username: fullNameTextField.text,
                avatarImageString: nil,
                description: aboutMeTextField.text,
                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
                    switch result {
                    case .success(let mUser):
                        self.showAlert(withTitle: "Success", andMessage: "Let's write your first message") {
                            let mainTabBar = MainTabBarController(currentUser: mUser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true)
                        }
                        print(mUser.username)
                    case .failure(let error):
                        self.showAlert(withTitle: "Failure", andMessage: error.localizedDescription)
                    }
                }
        }
    }

}

extension RegistrationViewController {

    func showAlert(withTitle title: String, andMessage message: String, completion: @escaping () -> () = { }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}

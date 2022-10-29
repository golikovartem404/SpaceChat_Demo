//
//  RegistrationViewController.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class RegistrationViewController: UIViewController {

    // MARK: - Properties

    private let currentUser: User

    // MARK: - Outlets

    let addPhotoView = AddPhotoView()

    let setupLabel = UILabel(
        text: "Set up profile",
        font: .avenir26()
    )
    let fullNameLabel = UILabel(
        text: "Full name"
    )
    let aboutMeLabel = UILabel(
        text: "About me"
    )
    let sexLabel = UILabel(
        text: "Sex"
    )

    let fullNameTextField = OneLineTextField(
        font: .avenir20()
    )
    let aboutMeTextField = OneLineTextField(
        font: .avenir20()
    )

    let sexSegmentedControl = UISegmentedControl(
        first: "Male",
        second: "Female"
    )

    let goToChatsButton = UIButton(
        title: "Go to chats",
        titleColor: .white,
        backgroundColor: .buttonBlack()
    )

    let fullNameStack = UIStackView(
        axis: .vertical,
        spacing: 0
    )
    let aboutMeStack = UIStackView(
        axis: .vertical,
        spacing: 0
    )
    let sexSegmentedStack = UIStackView(
        axis: .vertical,
        spacing: 10
    )
    let mainStackView = UIStackView(
        axis: .vertical,
        spacing: 40
    )

    // MARK: - Lifecycle

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        if let photoURL = currentUser.photoURL {
            addPhotoView.imageView.sd_setImage(with: photoURL, completed: nil)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        configureTargets()
    }

    // MARK: - Setups

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

    private func configureTargets() {
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonPressed), for: .touchUpInside)
        addPhotoView.plusButton.addTarget(self, action: #selector(addPhotoButtonPressed), for: .touchUpInside)
    }

    private func customizeElements() {
        fullNameTextField.delegate = self
        aboutMeTextField.delegate = self
    }
}

// MARK: - Actions for buttons extension

extension RegistrationViewController {

    @objc func goToChatsButtonPressed() {
        if let email = currentUser.email {
            FirestoreService.shared.saveProfileWith(
                id: currentUser.uid,
                email: email,
                username: fullNameTextField.text,
                avatarImage: addPhotoView.imageView.image,
                description: aboutMeTextField.text,
                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)
            ) { result in
                switch result {
                case .success(let mUser):
                    self.showAlert(
                        withTitle: "Success",
                        andMessage: "Let's write your first message"
                    ) {
                        let mainTabBar = MainTabBarController(currentUser: mUser)
                        mainTabBar.modalPresentationStyle = .fullScreen
                        self.present(mainTabBar, animated: true)
                    }
                    print(mUser.username)
                case .failure(let error):
                    self.showAlert(
                        withTitle: "Failure",
                        andMessage: error.localizedDescription
                    )
                }
            }
        }
    }

    @objc func addPhotoButtonPressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
}

// MARK: - TextField Extension

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        addPhotoView.imageView.image = image
    }
}

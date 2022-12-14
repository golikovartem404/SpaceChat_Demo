//
//  UserCollectionViewCell.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import UIKit
import SDWebImage

class UserCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    static var identifier = "UserCollectionViewCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "photoIcon")
        return imageView
    }()
    let usernameLabel = UILabel(
        text: "text",
        font: .laoSangamMN20()
    )
    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = . white
        setupHierarchy()
        setupLayout()
        customizeCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }

    private func setupHierarchy() {
        containerView.addSubview(imageView)
        containerView.addSubview(usernameLabel)
        addSubview(containerView)
    }

    private func setupLayout() {

        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(containerView)
            make.height.equalTo(containerView.snp.width)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(containerView).offset(7)
            make.trailing.equalTo(containerView).offset(-5)
            make.bottom.equalTo(containerView)
        }
    }

    private func customizeCell() {
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.userCellShadowColor().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else { return }
        usernameLabel.text = user.username
        guard let url = URL(string: user.avatarStringURL) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }

    override func prepareForReuse() {
        imageView.image = nil
        usernameLabel.text = nil
    }
}

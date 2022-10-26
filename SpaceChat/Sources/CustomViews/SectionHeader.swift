//
//  SectionHeader.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

class SectionHeader: UICollectionReusableView {

    static let identifier = "SectionHeader"

    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(title)
    }

    private func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }

    func cofigure(withText text: String, font: UIFont?, textColor: UIColor?) {
        title.textColor = textColor
        title.font = font
        title.text = text
    }

}

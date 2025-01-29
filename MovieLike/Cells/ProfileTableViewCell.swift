//
//  ProfileTableViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit

class ProfileTableViewCell: BaseTableViewCell {

    static let id = "ProfileTableViewCell"
    let titleLabel = UILabel()
    
    func configureData(inputText: String) {
        titleLabel.text = inputText
    }
    
    override func configureHierachy() {
        contentView.addSubview(titleLabel)
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(8)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
        }
    }
    override func configureView() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundColor = .black
    }

}

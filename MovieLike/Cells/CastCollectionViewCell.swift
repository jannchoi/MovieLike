//
//  CastCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit
import Kingfisher

class CastCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "CastCollectionViewCell"
    let profileImage = UIImageView()
    let name = UILabel()
    let character = UILabel()
    func configureData(item: CastDetail) {
        
        profileImage.setOptionalImage(imgPath: item.profile_path)
        
        name.labelDesign(inputText: item.name ?? "None", size: 14, weight: .bold, color: .white)
        character.labelDesign(inputText: item.character ?? "None", size: 12, color: .MylightGray)
        
    }
    
    override func configureHierachy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(name)
        contentView.addSubview(character)
    }
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
        }
        name.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.bottom.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(4)
        }
        character.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(4)
        }
    }
    override func configureView() {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.clipsToBounds = true
        }

    }
}

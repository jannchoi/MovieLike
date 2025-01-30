//
//  ProfileImageCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ProfileImageCollectionViewCell"
    let itemImage = UIImageView()
    
    func configImage(itemidx : Int, selected: Int) {
        itemImage.image = UIImage(named: "profile_\(itemidx)")
        if itemidx == selected {
            itemImage.layer.borderColor = UIColor.MyBlue.cgColor
            itemImage.layer.borderWidth = 2
            itemImage.alpha = 1.0
        } else {
            itemImage.layer.borderColor = UIColor.MyGray.cgColor
            itemImage.layer.borderWidth = 1
            itemImage.alpha = 0.5
        }
    }
    
    override func configureHierachy() {
        contentView.addSubview(itemImage)
    }
    override func configureLayout() {
        itemImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
        DispatchQueue.main.async {
            self.itemImage.layer.cornerRadius = self.itemImage.frame.height / 2
            self.itemImage.clipsToBounds = true
            self.itemImage.layer.borderWidth = 1
        }

    }
}

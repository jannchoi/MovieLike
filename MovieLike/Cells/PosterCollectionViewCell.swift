//
//  PosterCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit

class PosterCollectionViewCell: BaseCollectionViewCell {
    static let id = "PosterCollectionViewCell"
    let posterImage = UIImageView()
    
    func configureData(item: FileDetail) {
        posterImage.setOptionalImage(imgPath: item.file_path)
    }
    override func configureHierachy() {
        contentView.addSubview(posterImage)
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

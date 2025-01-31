//
//  BackDropCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit

final class BackDropCollectionViewCell: BaseCollectionViewCell {
    static let id = "BackDropCollectionViewCell"
    
    private let itemImage = UIImageView()
    func configureData(item: FileDetail) {

        itemImage.setOptionalImage(imgPath: item.file_path)
    }
    override func configureHierachy() {
        contentView.addSubview(itemImage)
    }
    override func configureLayout() {
        itemImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

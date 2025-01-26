//
//  SearchWordsCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class SearchWordsCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "SearchWordsCollectionViewCell"
    let word = UILabel()
    let xmark = UIImageView()
    override func configureHierachy() {
        contentView.addSubview(word)
        contentView.addSubview(xmark)
    }
    override func configureLayout() {
        word.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(4)
        }
        xmark.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview().inset(4)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = contentView.frame.height / 2
        word.textColor = .black
        
        xmark.image = UIImage(systemName: "xmark")
        xmark.tintColor = .black
    }
}

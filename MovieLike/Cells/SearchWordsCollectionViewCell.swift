//
//  SearchWordsCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

final class SearchWordsCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "SearchWordsCollectionViewCell"
    private let word = UILabel()
    let xButton = UIButton()
    
    func configureData(item: Int) {
        word.text = UserDefaultsManager.searchedTerm[item]
        xButton.tag = item
    }
    override func configureHierachy() {
        contentView.addSubview(word)
        contentView.addSubview(xButton)
    }
    override func configureLayout() {
        word.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(8)
            make.height.equalTo(16)
        }
        xButton.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalTo(word.snp.trailing).offset(2)
            make.size.equalTo(16)
        }
    }
    override func configureView() {
        contentView.backgroundColor = .white
        
        DispatchQueue.main.async {
            self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        }
        word.textColor = .black
        word.font = UIFont.systemFont(ofSize: 12)
        
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .black

    }

}

//
//  TodayMoviesCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class TodayMoviesCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "TodayMoviesCollectionViewCell"
    
    let posterImage = UIImageView()
    let title = UILabel()
    let descriptionLabel = UILabel()
    let heartButton = UIButton()
    override func configureHierachy() {
        contentView.addSubview(posterImage)
        contentView.addSubview(title)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(heartButton)
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(2)
            make.leading.equalTo(posterImage)
            make.height.equalTo(23)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        posterImage.layer.cornerRadius = 8
        
        title.labelDesign(inputText: "title", size: 20, weight: .bold, color: .white)
        descriptionLabel.labelDesign(inputText: "description", size: 10, color: .white)
    }
}

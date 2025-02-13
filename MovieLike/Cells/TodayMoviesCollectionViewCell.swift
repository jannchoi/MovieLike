//
//  TodayMoviesCollectionViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit
import Kingfisher

class TodayMoviesCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "TodayMoviesCollectionViewCell"
    
    let posterImage = UIImageView()
    let title = UILabel()
    let descriptionLabel = UILabel()
    private lazy var heartButton = HeartButton(id: tag)
    
    func configureData(item: MovieDetail) {
        posterImage.setOptionalImage(imgPath: item.poster_path)
        title.text = item.title
        descriptionLabel.text = item.overview
    }
    
    override func configureHierachy() {
        contentView.addSubview(posterImage)
        contentView.addSubview(title)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(heartButton)
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(2)
            make.height.equalToSuperview().inset(50)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(4)
            make.leading.equalTo(posterImage)
            make.horizontalEdges.equalToSuperview().inset(2)
            make.height.equalTo(23)
        }
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(2)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(2)
            make.height.equalTo(40)
        }
    }
    override func configureView() {
        posterImage.layer.cornerRadius = 8
        posterImage.clipsToBounds = true
        
        title.labelDesign(inputText: "title", size: 16, weight: .bold, color: .white)
        descriptionLabel.labelDesign(inputText: "description", size: 12, color: .white, lines: 2)
        heartButton.setAction()
    }
    
}

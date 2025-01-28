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
    let heartButton = UIButton()
    
    func configureData(item: MovieDetail) {
        if let url = item.poster_path {
            let img = URL(string: url.imagePathFormat())
           posterImage.kf.setImage(with: img)
        } else {
            posterImage.image = UIImage(systemName: "star")
        }
        title.text = item.title
        descriptionLabel.text = item.overview
        heartButton.tag = item.id
        if UserDefaultsManager.shared.like.contains(heartButton.tag) {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

    }
    
    @objc func heartButtonTapped1(_ sender:  UIButton) {
        if let idx = UserDefaultsManager.shared.like.firstIndex(of: sender.tag) {
            //만약에 값을 가지고 있다면, 제거, 빈 하트
            UserDefaultsManager.shared.like.remove(at: idx)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            print(sender.tag, "heart")
        } else { // 값이 없다면, 추가, 꽉찬 하트
            UserDefaultsManager.shared.like.append(sender.tag)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print(sender.tag, "heart.fill")
        }
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
            make.height.equalTo(330)
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
        heartButton.tintColor = .MyBlue
        heartButton.addTarget(self, action: #selector(heartButtonTapped1), for: .touchUpInside)
    }
    
}

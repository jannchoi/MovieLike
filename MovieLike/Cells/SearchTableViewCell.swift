//
//  SearchTableViewCell.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchTableViewCell: BaseTableViewCell {

    static let id = "SearchTableViewCell"
    
    let posterImage = UIImageView()
    let titleLable = UILabel()
    let dateLabel = UILabel()
    let genre1 = UILabel()
    let genre2 = UILabel()
    let heartButton = UIButton()
    
    func configureData(item: MovieDetail) {
        

        posterImage.setOptionalImage(imgPath: item.poster_path)
        titleLable.labelDesign(inputText: item.title, size: 14, weight: .bold, color: .white, lines: 2)

        dateLabel.labelDesign(inputText: item.release_date.dateFormat() ?? "None", size: 12, color: .MylightGray)
        
        heartButton.tag = item.id
        if UserDefaultsManager.shared.like.contains(heartButton.tag) {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        heartButton.tintColor = .MyBlue
        setGenre(ids: item.genre_ids)
        
    }
    @objc func heartButtonTapped2(_ sender:  UIButton) {
        if let idx = UserDefaultsManager.shared.like.firstIndex(of: sender.tag) {
            //만약에 값을 가지고 있다면, 제거, 빈 하트
            UserDefaultsManager.shared.like.remove(at: idx)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            print(sender.tag, "heart")
        } else { // 값이 없다면, 추가, 꽉찬 하트
            UserDefaultsManager.shared.like.append(sender.tag)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print(sender.tag, "heart.fil")
        }
    }
    
    func setGenre(ids: [Int]) {

        if ids.count >= 1, let genre1Text = GenreManager.shared.getGenre(ids[0]) {
            genre1.labelDesign(inputText: " " + genre1Text + " ", size: 12, color: .white)
            genre1.isHidden = false
        } else {
            genre1.isHidden = true
        }
        
        if ids.count >= 2, let genre2Text = GenreManager.shared.getGenre(ids[1]) {
            genre2.labelDesign(inputText: " " + genre2Text + " ", size: 12, color: .white)
            genre2.isHidden = false
        } else {
            genre2.isHidden = true
        }
        
    }
    
    override func configureHierachy() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLable)
        contentView.addSubview(dateLabel)
        contentView.addSubview(genre1)
        contentView.addSubview(genre2)
        contentView.addSubview(heartButton)
    }
    
    override func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(96)
        }
        titleLable.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.top.equalTo(posterImage)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.trailing.greaterThanOrEqualToSuperview().inset(8)
            make.top.equalTo(titleLable.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        
        genre1.snp.makeConstraints { make in
            make.leading.equalTo(posterImage.snp.trailing).offset(10)
            make.bottom.equalTo(posterImage.snp.bottom)
            make.height.equalTo(17)
        }

        genre2.snp.makeConstraints { make in
            make.leading.equalTo(genre1.snp.trailing).offset(2)
            make.centerY.equalTo(genre1)
            make.height.equalTo(17)
        }

        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(genre1)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    override func configureView() {
        backgroundColor = .black
        [genre1, genre2].forEach { label in
            label.backgroundColor = .darkGray
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
        }
        heartButton.addTarget(self, action: #selector(heartButtonTapped2), for: .touchUpInside)
        
    }
}

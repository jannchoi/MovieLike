//
//  CinemaView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class CinemaView: BaseView {
    let grayBackView = UIView()
    let profileImage = UIImageView()
    let nickname = UILabel()
    let dateLabel = UILabel()
    let angleBracket = UIImageView()
    let movieboxButton = UIButton()
    let searchLabel = UILabel()
    let noSearchedWord = UILabel()
    let deleteButton = UIButton()
    lazy var searchedWords = UICollectionView(frame: .zero, collectionViewLayout: searchedWordsLayout())
    let movieLabel = UILabel()
    lazy var movieCollection = UICollectionView(frame: .zero, collectionViewLayout: movieLayout())
    
    func searchedWordsLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let sectionInset: CGFloat = 1
        layout.itemSize = CGSize(width: 40, height: 21)
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        return layout
    }
    func movieLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let sectionInset: CGFloat = 1
        let cellWidth = 150
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 7 * 5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        return layout
    }

    override func configureHierachy() {
        addSubview(grayBackView)
        grayBackView.addSubview(profileImage)
        grayBackView.addSubview(nickname)
        grayBackView.addSubview(dateLabel)
        grayBackView.addSubview(angleBracket)
        grayBackView.addSubview(movieboxButton)
        addSubview(searchLabel)
        addSubview(deleteButton)
        addSubview(noSearchedWord)
        addSubview(searchedWords)
        addSubview(movieLabel)
        addSubview(movieCollection)
    }
    override func configureLayout() {
        grayBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(140)
        }
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(53)
        }
        nickname.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(6)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        angleBracket.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        movieboxButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(33)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.top.equalTo(grayBackView.snp.bottom).offset(12)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }
        searchedWords.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(2)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(50)
        }
        noSearchedWord.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        movieLabel.snp.makeConstraints { make in
            make.top.equalTo(searchedWords.snp.bottom).offset(4)
            make.leading.equalTo(8)
        }
        movieCollection.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.bottom).offset(4)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        grayBackView.backgroundColor = .darkGray

        nickname.labelDesign(inputText: "nickname", size: 20, weight : .bold, color: .white)
        dateLabel.labelDesign(inputText: "25.01.01 가입", size: 10, color: .MylightGray)
        noSearchedWord.labelDesign(inputText: "최근 검색어 내역이 없습니다.", size: 13, color: .MyGray)
        angleBracket.image = UIImage(systemName: "chevron.right")
        angleBracket.tintColor = .MyGray
        
        movieboxButton.backgroundColor = .MyBlue.withAlphaComponent(0.5)
        movieboxButton.setButtonTitle(title: "0 개의 무비박스 보관중", color: UIColor.white.cgColor, size: 17, weight: .bold)
        deleteButton.setButtonTitle(title: "전체 삭제", color: UIColor.MyBlue.cgColor, size: 14)
        
        searchLabel.labelDesign(inputText: "최근검색어", size: 20, weight: .bold, color: .white)
        movieLabel.labelDesign(inputText: "오늘의 영화", size: 20, weight: .bold, color: .white)
        
        searchedWords.tag = 0
        searchedWords.register(SearchWordsCollectionViewCell.self, forCellWithReuseIdentifier: SearchWordsCollectionViewCell.id)
        movieCollection.tag = 1
        movieCollection.register(TodayMoviesCollectionViewCell.self, forCellWithReuseIdentifier: TodayMoviesCollectionViewCell.id)
    }

}

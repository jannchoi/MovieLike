//
//  CinemaView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

final class CinemaView: BaseView {
    
    let profileView = ProfileBaseView()
    private let searchLabel = UILabel()
    let noSearchedWord = UILabel()
    let deleteButton = UIButton()
    lazy var searchedWords = UICollectionView(frame: .zero, collectionViewLayout: searchedWordsLayout())
    private let movieLabel = UILabel()
    lazy var movieCollection = UICollectionView(frame: .zero, collectionViewLayout: movieLayout())
    
    private func searchedWordsLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    private func movieLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }

    override func configureHierachy() {
        addSubview(profileView)
        addSubview(searchLabel)
        addSubview(deleteButton)
        addSubview(noSearchedWord)
        addSubview(searchedWords)
        addSubview(movieLabel)
        addSubview(movieCollection)
    }
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(136)
        }
        searchLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(18)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
        }
        searchedWords.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(2)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.trailing.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(8)
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
            make.top.equalTo(movieLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = .black
        noSearchedWord.labelDesign(inputText: "최근 검색어 내역이 없습니다.", size: 13, color: .MyGray)
        deleteButton.setButtonTitle(title: "전체 삭제", color: UIColor.MyBlue, size: 14)
        
        searchLabel.labelDesign(inputText: "최근검색어", size: 16, weight: .bold, color: .white)
        movieLabel.labelDesign(inputText: "오늘의 영화", size: 16, weight: .bold, color: .white)
        
        searchedWords.tag = 0
        searchedWords.register(SearchWordsCollectionViewCell.self, forCellWithReuseIdentifier: SearchWordsCollectionViewCell.id)
        searchedWords.backgroundColor = .black
        
        movieCollection.tag = 1
        movieCollection.register(TodayMoviesCollectionViewCell.self, forCellWithReuseIdentifier: TodayMoviesCollectionViewCell.id)
        movieCollection.backgroundColor = .black
    }

}

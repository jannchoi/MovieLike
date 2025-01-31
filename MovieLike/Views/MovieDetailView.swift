//
//  MovieDetailView.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit

final class MovieDetailView: BaseView {
    private let scrollView = UIScrollView()
    lazy var backDropView = UICollectionView(frame: .zero, collectionViewLayout: backDropLayout())
    let pager = UIPageControl()
    private let pagerBackView = UIView()
    let infoStackView = UIStackView()
    let dateLabel = UIButton()
    let rateLabel = UIButton()
    let genreLabel = UIButton()
    let synopsisLabel = UILabel()
    let moreButton = UIButton()
    let synopsisShort = UILabel()
    let synopsisLong = UILabel()
    let castLabel = UILabel()
    lazy var castView = UICollectionView(frame: .zero, collectionViewLayout: castLayout())
    let posterLabel = UILabel()
    lazy var posterView = UICollectionView(frame: .zero, collectionViewLayout: posterLayout())
    
    func backDropLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    func castLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let sectionInset: CGFloat = 4
        let cellSpacing: CGFloat = 4
        let ColViewHeight:CGFloat = 120
        let cellWidth = ColViewHeight - (sectionInset * 2) - (cellSpacing *  1)
        layout.itemSize = CGSize(width: cellWidth * 2, height: cellWidth / 2)
        layout.sectionInset = UIEdgeInsets(top: 1, left: sectionInset, bottom: 1, right: sectionInset)
        return layout
    }
    
    func posterLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let sectionInset: CGFloat = 4
        let ColViewHeight:CGFloat = 150
        let cellWidth = ColViewHeight - (sectionInset * 2)
        layout.itemSize = CGSize(width: cellWidth / 4 * 3, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        return layout
    }
    override func configureHierachy() {
        addSubview(scrollView)
        scrollView.addSubview(backDropView)
        scrollView.addSubview(pagerBackView)
        scrollView.addSubview(pager)
        scrollView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(dateLabel)
        infoStackView.addArrangedSubview(rateLabel)
        infoStackView.addArrangedSubview(genreLabel)
        scrollView.addSubview(synopsisLabel)
        scrollView.addSubview(moreButton)
        scrollView.addSubview(synopsisShort)
        scrollView.addSubview(synopsisLong)
        scrollView.addSubview(castLabel)
        scrollView.addSubview(castView)
        scrollView.addSubview(posterLabel)
        scrollView.addSubview(posterView)

    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        backDropView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(300)
        }
        pager.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(backDropView.snp.bottom).offset(-2)
        }
        pagerBackView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(pager)
            make.height.equalTo(pager).inset(2)
            make.width.equalTo(pager).inset(10)
        }
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(backDropView.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        rateLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        genreLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }
        synopsisLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
        synopsisShort.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(synopsisLabel.snp.bottom).offset(8)
        }
        synopsisLong.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(synopsisLabel.snp.bottom).offset(8)
        }
        synopsisLong.isHidden = true
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisShort.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(20)
        }
        castView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(8)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(120)
        }
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(castView.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(20)
        }
        posterView.snp.makeConstraints { make in
            make.top.equalTo(posterLabel.snp.bottom).offset(8)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(150)
            make.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        backgroundColor = .black

        synopsisLabel.labelDesign(inputText: "Synopsis", size: 16, weight: .bold ,color: .white)
        castLabel.labelDesign(inputText: "Cast", size: 16, weight: .bold, color: .white)
        posterLabel.labelDesign(inputText: "Poster", size: 16, weight: .bold, color: .white)
        synopsisShort.labelDesign(inputText: "", size: 12, color: .white, lines: 3)
        synopsisLong.labelDesign(inputText: "", size: 12, color: .white)
        
        moreButton.setButtonTitle(title: "More", color: .MyBlue, size: 14, weight: .bold)
        
        backDropView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.id)
        backDropView.tag = 0
        backDropView.backgroundColor = .black
        castView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        castView.tag = 1
        castView.backgroundColor = .black
        posterView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
        posterView.tag = 2
        posterView.backgroundColor = .black
        
        infoStackView.axis = .horizontal
        infoStackView.spacing = 4
        
        pagerBackView.backgroundColor = .darkGray

        
    }
    func updateViewLayout() {
        pagerBackView.layer.cornerRadius = pagerBackView.frame.height / 2
    }
    
    
}

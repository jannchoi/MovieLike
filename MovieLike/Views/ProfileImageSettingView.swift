//
//  ProfileImageSettingView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class ProfileImageSettingView: BaseView {
    
    let selectedImage = UIImageView()
    lazy var profileImages = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let sectionInset: CGFloat = 1
        let cellSpacing: CGFloat = 2
        let ColViewWidth:CGFloat = UIScreen.main.bounds.width - 40
        let cellWidth = ColViewWidth - (sectionInset * 2) - (cellSpacing *  3)
        layout.itemSize = CGSize(width: cellWidth / 5, height: cellWidth / 5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    override func configureHierachy() {
        addSubview(selectedImage)
        addSubview(profileImages)
    }
    override func configureLayout() {
        selectedImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(70)
        }
        
        profileImages.snp.makeConstraints { make in
            make.top.equalTo(selectedImage.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(230)
        }
    }
    override func configureView() {
        profileImages.backgroundColor = .black
        profileImages.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
}

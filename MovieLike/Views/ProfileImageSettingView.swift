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
    let cameraSymbol = UIImageView()
    let cameraBack = UIView()
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
        addSubview(cameraBack)
        addSubview(cameraSymbol)
    }
    override func configureLayout() {
        selectedImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(80)
        }
        cameraSymbol.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(selectedImage)
            make.size.equalTo(27)
        }
        cameraBack.snp.makeConstraints { make in
            make.center.equalTo(cameraSymbol)
            make.size.equalTo(15)
        }
        
        profileImages.snp.makeConstraints { make in
            make.top.equalTo(selectedImage.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(230)
        }
    }
    override func configureView() {
        backgroundColor = .black
        profileImages.backgroundColor = .black
        profileImages.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
        
        cameraSymbol.image = UIImage(systemName: "camera.circle.fill")
        cameraSymbol.tintColor = .MyBlue
        cameraBack.backgroundColor = .white
        
    }
    func updateViewLayout() {
        selectedImage.layer.cornerRadius = selectedImage.frame.height / 2
        selectedImage.clipsToBounds = true
        selectedImage.layer.borderWidth = 2
        selectedImage.layer.borderColor = UIColor.MyBlue.cgColor
        
        cameraSymbol.layer.cornerRadius = cameraSymbol.frame.height / 2
        cameraSymbol.clipsToBounds = true
    }
}

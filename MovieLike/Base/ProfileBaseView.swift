//
//  ProfileBaseView.swift
//  MovieLike
//
//  Created by 최정안 on 1/30/25.
//

import UIKit
import SnapKit

class ProfileBaseView: BaseView {
    
    let grayBackView = UIView()
    let profileImage = UIImageView()
    let nickname = UILabel()
    let dateLabel = UILabel()
    let angleBracket = UIImageView()
    let movieboxButton = UIButton()
    
    override func configureHierachy() {
        addSubview(grayBackView)
        grayBackView.addSubview(profileImage)
        grayBackView.addSubview(nickname)
        grayBackView.addSubview(dateLabel)
        grayBackView.addSubview(angleBracket)
        grayBackView.addSubview(movieboxButton)
    }
    override func configureLayout() {
        grayBackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(136)
        }
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(55)
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
    }
    override func configureView() {
        grayBackView.backgroundColor = .darkGray

        nickname.labelDesign(inputText: "nickname", size: 16, weight : .bold, color: .white)
        dateLabel.labelDesign(inputText: "25.01.01 가입", size: 12, color: .MylightGray)
        angleBracket.image = UIImage(systemName: "chevron.right")
        angleBracket.tintColor = .MyGray
        
        movieboxButton.backgroundColor = .MyBlue.withAlphaComponent(0.5)
        movieboxButton.setButtonTitle(title: "0 개의 무비박스 보관중", color: UIColor.white, size: 16, weight: .bold)
    }
    
    func updateViewLayout()
    {
        movieboxButton.layer.cornerRadius = 8
        movieboxButton.clipsToBounds = true
        
        grayBackView.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.MyBlue.cgColor
    }
    
    func updateProfile() {
        let data = UserDefaultsManager.shared
        profileImage.image = UIImage(named: "profile_\(data.profileImage)")
        nickname.text = data.nickname
        dateLabel.text = data.signDate + " 가입"
        movieboxButton.setButtonTitle(title: "\(data.like.count) 개의 무비박스 보관중", color: UIColor.white, size: 16, weight: .bold)
    }
}

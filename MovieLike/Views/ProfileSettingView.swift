//
//  ProfileSettingView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

class ProfileSettingView: BaseView {
    
    let profileImageButton = UIButton()
    let nicknameTextField = UITextField()
    let descriptionLabel = UILabel()
    let finishButton = UIButton()
    
    override func configureHierachy() {
        addSubview(profileImageButton)
        addSubview(nicknameTextField)
        addSubview(descriptionLabel)
        addSubview(finishButton)
    }
    override func configureLayout() {
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(70)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
    }
    override func configureView() {
        nicknameTextField.borderStyle = .none
                descriptionLabel.labelDesign(inputText: "2글자 이상 10글자 미만으로 설정해주세요", size: 10, color: .MyBlue)
        
        

        finishButton.setButtonTitle(title: "완료", color: UIColor.MyBlue.cgColor, size: 17, weight: .bold)
        finishButton.backgroundColor = .black

    }

}

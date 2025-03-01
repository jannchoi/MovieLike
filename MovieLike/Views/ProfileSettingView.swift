//
//  ProfileSettingView.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
import SnapKit

final class ProfileSettingView: BaseView {
    
    let profileImageButton = UIButton()
    let nicknameTextField = UITextField()
    let descriptionLabel = UILabel()
    let finishButton = UIButton()
    let cameraSymbol = UIImageView()
    private let cameraBack = UIView()
    
    let mbtiLabel = UILabel()
    
    let mbtiStackView = UIStackView()
    
    let EIStackView = UIStackView()
    let SNStackView = UIStackView()
    let TFStackView = UIStackView()
    let JPStackView = UIStackView()
    
    lazy var stackViews = [EIStackView, SNStackView, TFStackView, JPStackView]

    override func configureHierachy() {
        addSubview(profileImageButton)
        addSubview(nicknameTextField)
        addSubview(descriptionLabel)
        addSubview(finishButton)
        addSubview(cameraBack)
        addSubview(cameraSymbol)
        addSubview(mbtiLabel)
        addSubview(mbtiStackView)
        mbtiStackView.addArrangedSubview(EIStackView)
        mbtiStackView.addArrangedSubview(SNStackView)
        mbtiStackView.addArrangedSubview(TFStackView)
        mbtiStackView.addArrangedSubview(JPStackView)
    }
    override func configureLayout() {
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(80)
        }
        cameraSymbol.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageButton)
            make.size.equalTo(27)
        }
        cameraBack.snp.makeConstraints { make in
            make.center.equalTo(cameraSymbol)
            make.size.equalTo(15)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(17)
        }
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        arrangeStackView()
        mbtiStackView.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.width.equalTo(270)
            make.height.equalTo(130)        }

        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        

    }
    private func arrangeStackView() {
        mbtiStackView.backgroundColor = .black
        mbtiStackView.axis = .horizontal
        mbtiStackView.spacing = 10
        
        let charList = [["E", "I"], ["S", "N"], ["T", "F"], ["J", "P"]]
        
        
        for (idx, stackview) in stackViews.enumerated() {
            stackview.axis = .vertical
            stackview.spacing = 10
            stackview.tag = idx
            for char in charList[idx] {
                let button = UIButton()
                button.setTitle(char, for: .normal)
                button.setTitleColor(.MyGray, for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.MyGray
                    .cgColor
                stackview.addArrangedSubview(button)
                
                button.snp.makeConstraints { make in
                    make.size.equalTo(60)
                }
            }
            
        }
        
    }
    override func configureView() {
        backgroundColor = .black
        nicknameTextField.borderStyle = .none
                descriptionLabel.labelDesign(inputText: "2글자 이상 10글자 미만으로 설정해주세요", size: 12, color: .MyBlue)
        finishButton.setButtonTitle(title: "완료", color: UIColor.white, size: 16, weight: .bold)
        finishButton.backgroundColor = .black
        cameraSymbol.image = UIImage(systemName: "camera.circle.fill")
        cameraSymbol.tintColor = .MyBlue
        cameraBack.backgroundColor = .white
        mbtiLabel.labelDesign(inputText: "MBTI", size: 16, weight: .bold)

    }
    func updateViewLayout() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height - 1, width: nicknameTextField.frame.size.width, height: 1)
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = CGFloat(1.0)
        nicknameTextField.layer.addSublayer(border)
        nicknameTextField.layer.masksToBounds = true
        nicknameTextField.textColor = .white
        
        finishButton.layer.cornerRadius = finishButton.frame.height / 2
        finishButton.clipsToBounds = true
        finishButton.layer.borderWidth = 1
        finishButton.layer.borderColor = UIColor.MyBlue.cgColor
        
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 3
        profileImageButton.layer.borderColor = UIColor.MyBlue.cgColor
        
        cameraSymbol.layer.cornerRadius = cameraSymbol.frame.height / 2
        cameraSymbol.clipsToBounds = true
    }

}

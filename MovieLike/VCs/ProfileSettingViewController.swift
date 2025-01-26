//
//  ProfileSettingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class ProfileSettingViewController: UIViewController {

    let mainView = ProfileSettingView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.backgroundColor = .Myblack
        mainView.finishButton.isEnabled = false
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            let border = CALayer()
        border.frame = CGRect(x: 0, y: mainView.nicknameTextField.frame.size.height - 1, width: mainView.nicknameTextField.frame.size.width, height: 1)
            border.borderColor = UIColor.white.cgColor
            border.borderWidth = CGFloat(1.0)
        mainView.nicknameTextField.layer.addSublayer(border)
        mainView.nicknameTextField.layer.masksToBounds = true
        mainView.nicknameTextField.textColor = .white

        mainView.finishButton.layer.cornerRadius = mainView.finishButton.frame.height / 2
        mainView.finishButton.clipsToBounds = true
        mainView.finishButton.layer.borderWidth = 1
        mainView.finishButton.layer.borderColor = UIColor.MyBlue.cgColor
        
        mainView.profileImageButton.layer.cornerRadius = mainView.profileImageButton.frame.height / 2
        mainView.profileImageButton.clipsToBounds = true
        mainView.profileImageButton.layer.borderWidth = 1
        mainView.profileImageButton.layer.borderColor = UIColor.MyBlue.cgColor
        
        
    }
    
    @objc func textFieldDidChange() {
        guard let input = mainView.nicknameTextField.text else {return}
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        var description : String
        if trimmedInput.count < 2 || trimmedInput.count > 10 {
            description = "2글자 이상 10글자 미만으로 설정해 주세요."
            mainView.finishButton.isEnabled = false
        } else if trimmedInput.contains(where: {"@#$%".contains($0)}) {
            description = "닉네임에 @,#,$,%는 포함할 수 없어요."
            mainView.finishButton.isEnabled = false
        } else if trimmedInput.contains(where: {"123456789".contains($0)}) {
            description = "닉네임에 숫자는 포함할 수 없어요."
            mainView.finishButton.isEnabled = false
        } else {
            description = "사용할 수 있는 닉네임이에요."
            mainView.finishButton.isEnabled = true
        }
        mainView.descriptionLabel.text = description
    }
    

}

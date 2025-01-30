//
//  ProfileSettingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class ProfileSettingViewController: UIViewController {

    let mainView = ProfileSettingView()
    var initialImage = Int.random(in: 0...11)
    var fromProfileView = false
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.text = "프로필 설정"
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel

        mainView.finishButton.addTarget(self, action: #selector(finishButtonClicked), for: .touchUpInside)
        
        mainView.nicknameTextField.resignFirstResponder()
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.nicknameTextField.delegate = self
        
        mainView.profileImageButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
        
        if fromProfileView {
            setNavigationBar()
            mainView.finishButton.isHidden = true
            
        }
        else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem?.tintColor = .MyBlue

        }
    }
    @objc func backButtonTapped() {
        dismiss(animated: true)

    }
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveProfile))
        navigationItem.rightBarButtonItem?.tintColor = .MyBlue
        navigationItem.leftBarButtonItem?.tintColor = .MyBlue
    }
    
    @objc func saveProfile() {
        UserDefaultsManager.shared.nickname = mainView.nicknameTextField.text!
        UserDefaultsManager.shared.profileImage = initialImage
        presentingViewController?.viewWillAppear(true)
        dismiss(animated: true)
    }
    @objc func finishButtonClicked() {
        UserDefaultsManager.shared.nickname = mainView.nicknameTextField.text!
        UserDefaultsManager.shared.profileImage = initialImage
        UserDefaultsManager.shared.signDate = Date().DateToString()
        UserDefaultsManager.shared.used = true

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let tabbar = TabBarController()
        let nav = UINavigationController(rootViewController: tabbar)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            window.rootViewController = nav
            window.makeKeyAndVisible()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateViewLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let userdefaults = UserDefaultsManager.shared
        
        if initialImage == userdefaults.profileImage || userdefaults.profileImage == 0 {
            mainView.profileImageButton.setImage(UIImage(named: "profile_\(initialImage)"), for: .normal)
        }else {
            initialImage = userdefaults.profileImage
            mainView.profileImageButton.setImage(UIImage(named: "profile_\(initialImage)"), for: .normal)
        }
        
        if userdefaults.nickname != "" {
            mainView.nicknameTextField.text = userdefaults.nickname
        }
        isValidNickname()

    }
    @objc func profileImageTapped() {
        let vc = ProfileImageSettingViewController()
        vc.passData = { data in
            if let data {
                self.initialImage = data
            } else {
                return self.initialImage
            }
            return nil
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange() {
        isValidNickname()
    }
    func isValidNickname() {
        guard let input = mainView.nicknameTextField.text else {return}
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        var description : String
        if trimmedInput.count < 2 || trimmedInput.count >= 10 {
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
extension ProfileSettingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

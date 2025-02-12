//
//  ProfileSettingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit
final class ProfileSettingViewController: UIViewController {

    private let mainView = ProfileSettingView()
    let viewModel = ProfileSettingViewModel()
    
    var initialImage = Int.random(in: 0...11)
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.nicknameTextField.becomeFirstResponder()
        setAction()
        bindData()
    }
    private func bindData() {
        
        viewModel.isEditMode.bind { editMode in
            self.setNavigationBar(mode: editMode)
        }
        viewModel.output.preparedMBTI.bind { status in
            self.setMBTIButtonStatus(list : status)
        }
        viewModel.output.image.bind { img in
            self.mainView.profileImageButton.setImage(UIImage(named: img), for: .normal)
        }
        viewModel.output.descriptionLabel.bind { text in
            self.mainView.descriptionLabel.text = text
        }
        viewModel.output.nicknameIsValid.bind { bool in
            self.mainView.descriptionLabel.textColor = bool ? .MyBlue : .red
        }
        
        viewModel.output.isButtonEnable.bind { bool in
            self.mainView.finishButton.isEnabled = bool
            self.changeFinishButtonColor(isenabled: bool)
            self.navigationItem.rightBarButtonItem?.isEnabled = bool
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateButtons()
        
    }
    private func changeFinishButtonColor(isenabled: Bool) {
        var color = UIColor.white
        if isenabled {
            color = .MyBlue
        } else {
            color = .MyGray
        }
        mainView.finishButton.backgroundColor = color
        mainView.finishButton.layer.borderColor = color.cgColor
    }
    private func updateButtons() {
        for stackview in mainView.stackViews {
            for view in stackview.arrangedSubviews {
                guard let button = view as? UIButton else {return}
                button.layer.cornerRadius = button.frame.width / 2
                button.addTarget(self, action: #selector(changeButtonStatus), for: .touchUpInside)
            }
        }
    }
    @objc private func changeButtonStatus(_ sender: UIButton) {
        guard let stackview = sender.superview as? UIStackView else {return}
        
        let buttons = stackview.arrangedSubviews.map{$0 as? UIButton}
        guard let buttons = buttons as? [UIButton] else {return}
        if sender.isSelected {
            sender.isSelected = false
        } else {
            if buttons[0].isSelected || buttons[1].isSelected {
                buttons[0].isSelected.toggle()
                buttons[1].isSelected.toggle()
            } else {
                sender.isSelected = true
            }
        }
        changeButtonColor(buttons: buttons)

        if buttons[0].isSelected || buttons[1].isSelected {
            let selected = buttons[0].isSelected ? (buttons[0].title(for: .normal), 0) : (buttons[1].title(for: .normal), 1)
            viewModel.input.selectedButtons.value[stackview.tag] = selected

        }else {
            viewModel.input.selectedButtons.value[stackview.tag] = (nil,nil)
        }
        
    }
    private func changeButtonColor(buttons: [UIButton]) {
        for button in buttons {
            if button.isSelected {
                button.backgroundColor = .MyBlue
                button.layer.borderColor = UIColor.MyBlue.cgColor
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .black
                button.layer.borderColor = UIColor.MyGray.cgColor
                button.setTitleColor(.MyGray, for: .normal)
            }
        }
    }
    private func setAction() {
        mainView.finishButton.addTarget(self, action: #selector(finishButtonClicked), for: .touchUpInside)
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.nicknameTextField.delegate = self
        
        mainView.profileImageButton.addTarget(self, action: #selector(profileImageTapped), for: .touchUpInside)
    }
    @objc func backButtonTapped() {
        dismiss(animated: true)

    }
    @objc func backToOnboardingView() {
        navigationController?.popViewController(animated: true)
    }
    private func setNavigationBar(mode: Bool) {
        if mode {
            self.mainView.finishButton.isHidden = true
            navigationItem.setBarTitleView(title: "프로필 편집")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveProfile))
            navigationItem.rightBarButtonItem?.tintColor = .MyBlue
            navigationItem.leftBarButtonItem?.tintColor = .MyBlue
        } else {
            navigationItem.setBarTitleView(title: "프로필 설정")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToOnboardingView))
            navigationItem.leftBarButtonItem?.tintColor = .MyBlue
        }

    }
    @objc func saveProfile() {
        viewModel.input.finishButtonTrigger.value = mainView.nicknameTextField.text
        dismiss(animated: true)
    }
    @objc func finishButtonClicked() {
        viewModel.input.finishButtonTrigger.value = mainView.nicknameTextField.text

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let tabbar = TabBarController()
        let nav = UINavigationController(rootViewController: tabbar)
        nav.setBarAppearance()
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateViewLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.output.preparedNickname.bind { nickname in
            self.mainView.nicknameTextField.text = nickname
        }

    }
    private func setMBTIButtonStatus(list:[Int]) {
        for (idx,selected) in list.enumerated() {
            let buttons = mainView.stackViews[idx].arrangedSubviews.map{$0 as? UIButton}
            guard let buttons = buttons as? [UIButton] else {return}
            buttons[selected].isSelected = true
            changeButtonColor(buttons: buttons)
        }
    }
    @objc func profileImageTapped() {
        let vc = ProfileImageSettingViewController()
        vc.viewModel.input.passData.value = { data in
            if let data {
                self.viewModel.initialImage = data
                self.mainView.profileImageButton.setImage(UIImage(named: "profile_\(data)"), for: .normal)
            } else {
                return self.viewModel.initialImage
            }
            return nil
        }
        vc.viewModel.isEditMode = viewModel.isEditMode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange() {
        viewModel.input.nickname.value = mainView.nicknameTextField.text
    }

}
extension ProfileSettingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

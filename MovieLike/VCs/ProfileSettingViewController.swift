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
        print(#function, viewModel.initialImage)
        bindData()
    }
    private func bindData() {
        
        viewModel.isEditMode.bind {[weak self] editMode in // 초기 설정 상태인지 편집모드인지에 따라 네비게이션 제목을 다르게 설정
            self?.setNavigationBar(mode: editMode)
        }
        viewModel.output.preparedMBTI.bind {[weak self] status in // 편집모드일 경우 저장된 mbti에 맞게 표시
            self?.setMBTIButtonStatus(list : status)
        }
        viewModel.output.image.bind {[weak self] img in
            print(img)
            self?.mainView.profileImageButton.setImage(UIImage(named: img), for: .normal)
        }
        viewModel.output.descriptionLabel.bind {[weak self] text in // 닉네임 값이 달라질 때마다 조건 변경
            self?.mainView.descriptionLabel.text = text
        }
        viewModel.output.nicknameIsValid.bind {[weak self] bool in // 닉네임 조건 충족 여부에 따라 조건 레이블 색 변경
            self?.mainView.descriptionLabel.textColor = bool ? .MyBlue : .red
        }
        
        viewModel.output.isButtonEnable.bind {[weak self] bool in // 닉네임, mbti의 조건 충족 여부에 따라 완료버튼, 저장 버튼 enable 상태 변경
            self?.mainView.finishButton.isEnabled = bool
            self?.changeFinishButtonColor(isenabled: bool)
            self?.navigationItem.rightBarButtonItem?.isEnabled = bool
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateButtons()
        
    }
    private func changeFinishButtonColor(isenabled: Bool) { // 완료 버튼 색깔 변경
        var color = UIColor.white
        if isenabled {
            color = .MyBlue
        } else {
            color = .MyGray
        }
        mainView.finishButton.backgroundColor = color
        mainView.finishButton.layer.borderColor = color.cgColor
    }
    private func updateButtons() { // mbti 버튼 액션 연결
        for stackview in mainView.stackViews {
            for view in stackview.arrangedSubviews {
                guard let button = view as? UIButton else {return}
                button.layer.cornerRadius = button.frame.width / 2
                button.addTarget(self, action: #selector(changeButtonStatus), for: .touchUpInside)
            }
        }
    }
    @objc private func changeButtonStatus(_ sender: UIButton) { // 버튼 상태 변경
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

        if buttons[0].isSelected || buttons[1].isSelected { // 상태에 따라 최종mbti버튼 리스트 업데이트
            let selected = buttons[0].isSelected ? (buttons[0].title(for: .normal), 0) : (buttons[1].title(for: .normal), 1)
            viewModel.input.selectedButtons.value[stackview.tag] = selected

        }else {
            viewModel.input.selectedButtons.value[stackview.tag] = (nil,nil)
        }
        
    }
    private func changeButtonColor(buttons: [UIButton]) { // mbti버튼 색깔 변경
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
    @objc func saveProfile() { // 닉네임 전달, 데이터 userdefaults 저장
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
    override func viewWillAppear(_ animated: Bool) { // 저장된 닉네임 textfield에 setting
        viewModel.output.preparedNickname.bind { nickname in
            self.mainView.nicknameTextField.text = nickname
        }

    }
    private func setMBTIButtonStatus(list:[Int]) { // 저장된 mbti버튼 setting
        for (idx,selected) in list.enumerated() {
            let buttons = mainView.stackViews[idx].arrangedSubviews.map{$0 as? UIButton}
            guard let buttons = buttons as? [UIButton] else {return}
            buttons[selected].isSelected = true
            changeButtonColor(buttons: buttons)
        }
    }
    @objc func profileImageTapped() { // 프로필 이미지뷰로 이동, 이미지 전달
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

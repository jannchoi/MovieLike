//
//  ProfileViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let mainView = ProfileView()
    //private let category = ["자주 묻는 질문", "1:1문의", "알림 설정", "탈퇴하기"]
    
    let viewModel = ProfileViewModel()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        mainView.profileView.grayBackView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsChanged), name: NSNotification.Name("UserDefaultsChanged"), object: nil)
        
        self.tabBarController?.navigationItem.title = "설정"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.leftBarButtonItem = nil

    }
    @objc func userDefaultsChanged() {
        mainView.profileView.updateProfile()
    }
    private func setDelegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.profileView.updateProfile()
        mainView.tableView.reloadData()
        
    }
    @objc func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.viewModel.isEditMode.value = true
        let nav = UINavigationController(rootViewController: vc)
        nav.sheetPresentationController?.prefersGrabberVisible = true
        present(nav, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileView.updateViewLayout()
        
    }
    private func resetUserdefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }

}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.id) as? ProfileTableViewCell else {return UITableViewCell()}
        cell.configureData(inputText: viewModel.output.category[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .destructive) { action in
                self.resetUserdefaults()
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        , let window = windowScene.windows.first else {return}
                window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                window.makeKeyAndVisible()
                
            }
            let cancel = UIAlertAction(title: "취소", style: .default)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        tableView.reloadData()

    }
    
}

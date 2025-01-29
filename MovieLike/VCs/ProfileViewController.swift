//
//  ProfileViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class ProfileViewController: UIViewController {

    let mainView = ProfileView()
    let category = ["자주 묻는 질문", "1:1문의", "알림 설정", "탈퇴하기"]
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        mainView.grayBackView.addGestureRecognizer(tapGesture)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "설정"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        setProfile()
        mainView.tableView.reloadData()
        
    }
    @objc func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.fromProfileView = true
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
        
    }
    func setProfile() {
        let data = UserDefaultsManager.shared
        mainView.profileImage.image = UIImage(named: "profile_\(data.profileImage)")
        mainView.nickname.text = data.nickname
        mainView.dateLabel.text = data.signDate + " 가입"
        mainView.movieboxButton.setButtonTitle(title: "\(data.like.count) 개의 무비박스 보관중", color: UIColor.white.cgColor, size: 17, weight: .bold)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.movieboxButton.layer.cornerRadius = 8
        mainView.movieboxButton.clipsToBounds = true
        
        mainView.grayBackView.layer.cornerRadius = 8
        mainView.profileImage.layer.cornerRadius = mainView.profileImage.frame.height / 2
        mainView.profileImage.clipsToBounds = true
        mainView.profileImage.layer.borderWidth = 1
        mainView.profileImage.layer.borderColor = UIColor.MyBlue.cgColor
        
    }

}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.id) as! ProfileTableViewCell
        cell.configureData(inputText: category[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func resetUserdefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
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
    }
    
}

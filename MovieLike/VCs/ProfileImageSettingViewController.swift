//
//  ProfileImageSettingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class ProfileImageSettingViewController: BaseViewController {

    let mainView = ProfileImageSettingView()
    var selectedItem : Int?
    var passData : ((Int?) -> (Int?))?
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "프로필 이미지 설정"
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
        
        selectedItem = passData?(nil)
        setDelegate()
        mainView.selectedImage.image = UIImage(named: "profile_\(selectedItem!)")
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToProfileSetting))
        navigationItem.leftBarButtonItem?.tintColor = .MyBlue
    }
    func setDelegate() {
        mainView.profileImages.delegate = self
        mainView.profileImages.dataSource = self
    }
    @objc func backToProfileSetting() {
        UserDefaultsManager.shared.profileImage = selectedItem ?? 0
        passData?(selectedItem)
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateViewLayout()
    }


}

extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
        cell.configImage(itemidx: indexPath.item, selected: selectedItem!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
        mainView.selectedImage.image = UIImage(named: "profile_\(selectedItem!)")
        collectionView.reloadData()
    }
    
}

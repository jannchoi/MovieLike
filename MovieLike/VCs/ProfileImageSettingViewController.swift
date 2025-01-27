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
        mainView.profileImages.delegate = self
        mainView.profileImages.dataSource = self
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToProfileSetting))
    }
    @objc func backToProfileSetting() {
        passData?(selectedItem)
        navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        mainView.selectedImage.image = UIImage(named: "profile_\(selectedItem!)")
        mainView.selectedImage.layer.cornerRadius = mainView.selectedImage.frame.height / 2
        mainView.selectedImage.clipsToBounds = true
        mainView.selectedImage.layer.borderWidth = 1
        mainView.selectedImage.layer.borderColor = UIColor.MyBlue.cgColor
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

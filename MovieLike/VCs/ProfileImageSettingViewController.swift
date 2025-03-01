//
//  ProfileImageSettingViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController {

    private let mainView = ProfileImageSettingView()
    let viewModel = ProfileImageSettingViewModel()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        
    
        bindData()
    }
    private func bindData() {
        viewModel.isEditMode.bind {[weak self] editMode in // 초기 설정인지 편집상태인지에 따라 상단 바 제목 변경
            self?.setNavigationBar(mode: editMode)
        }
        viewModel.output.selectedItem.bind {[weak self] num in // 이미지를 선택할 때마다 메인 이미지 변경
            guard let num else {return}
            self?.mainView.selectedImage.image = UIImage(named: "profile_\(num)")
        }
    }
    
    private func setNavigationBar(mode: Bool) {
        if mode {
            navigationItem.setBarTitleView(title: "프로필 이미지 편집")
        } else {
            navigationItem.setBarTitleView(title: "프로필 이미지 설정")
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToProfileSetting))
        navigationItem.leftBarButtonItem?.tintColor = .MyBlue
    }
    private func setDelegate() {
        mainView.profileImages.delegate = self
        mainView.profileImages.dataSource = self
    }
    @objc func backToProfileSetting() {
        viewModel.input.passData.value?(viewModel.output.selectedItem.value)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configImage(itemidx: indexPath.item, selected: viewModel.output.selectedItem.value!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didSelectedItemIndex.value = indexPath.item
        collectionView.reloadData()
    }
    
}

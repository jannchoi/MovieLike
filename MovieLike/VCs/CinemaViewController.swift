//
//  CinemaViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class CinemaViewController: UIViewController {
    let mainView = CinemaView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .black
        mainView.searchedWords.delegate = self
        mainView.searchedWords.dataSource = self
        
        mainView.movieCollection.delegate = self
        mainView.movieCollection.dataSource = self
        
        mainView.movieboxButton.isEnabled = false
        setProfile()
    }
    func setProfile() {
        let img = UserDefaultsManager.shared.profileImage
        mainView.profileImage.image = UIImage(named: "profile_\(img)")
        mainView.nickname.text = UserDefaultsManager.shared.nickname
        mainView.dateLabel.text = UserDefaultsManager.shared.signDate + " 가입"
    }
    
    override func viewDidLayoutSubviews() {
        mainView.movieboxButton.layer.cornerRadius = 8
        mainView.movieboxButton.clipsToBounds = true
        
        mainView.grayBackView.layer.cornerRadius = 8
        mainView.profileImage.layer.cornerRadius = mainView.profileImage.frame.height / 2
        mainView.profileImage.clipsToBounds = true
        mainView.profileImage.layer.borderWidth = 1
        mainView.profileImage.layer.borderColor = UIColor.MyBlue.cgColor
        
        
    }

}
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0 : return 10
        default: return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell
        switch collectionView.tag {
        case 0 : cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchWordsCollectionViewCell.id, for: indexPath) as! SearchWordsCollectionViewCell
        default : cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMoviesCollectionViewCell.id, for: indexPath) as! TodayMoviesCollectionViewCell
        }
        cell.backgroundColor = .MyBlue
        
        return cell
    }
    
    
}

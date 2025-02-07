//
//  CinemaViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

final class CinemaViewController: UIViewController {
    private let mainView = CinemaView()
    
    let viewModel = CinemaViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController)
        setDelegate()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        mainView.profileView.grayBackView.addGestureRecognizer(tapGesture)
        mainView.deleteButton.addTarget(self, action: #selector(resetSearchedTerm), for: .touchUpInside)
        
        viewModel.movieList.bind { _ in
            self.mainView.movieCollection.reloadData()
        }
        viewModel.errorMessage.bind { message in
            if let message {
                self.showAlert(title: "Error", text: message, button: nil)
            }
        }
        
        viewModel.userdefaultsSearchedTerm.bind { _ in
            self.mainView.searchedWords.reloadData()
        }
        
        viewModel.isShowSearchedWords.bind { bool in
            self.switchSearchedTermView(isShowTable: bool)
        }

    }
    private func setDelegate() {
        mainView.searchedWords.delegate = self
        mainView.searchedWords.dataSource = self

        mainView.movieCollection.delegate = self
        mainView.movieCollection.dataSource = self
    }
    
    @objc func resetSearchedTerm() {
        viewModel.inputResetSearchedTermTapped.value = ()
        viewModel.inputUpdateSearchedTerm.value = ()
        //UserDefaultsManager.shared.searchedTerm.removeAll()
        //mainView.searchedWords.reloadData()
        //switchSearchedTermView()

    }

    @objc func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.editProfile = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    private func navigationBarDesign() {
        self.tabBarController?.navigationItem.title = "오늘의 영화"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .MyBlue
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarDesign()
        mainView.profileView.updateProfile()
        
 
        //mainView.searchedWords.reloadData()
        //switchSearchedTermView()
        
    }
    
    private func switchSearchedTermView(isShowTable: Bool) {
        if !isShowTable {
            mainView.noSearchedWord.isHidden = false
            mainView.searchedWords.isHidden = true
        } else {
            mainView.noSearchedWord.isHidden = true
            mainView.searchedWords.isHidden = false
        }
    }
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        vc.searchButtonClicked = true
        navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.profileView.updateViewLayout()
        movieCollectionLayout()
        
    }
    
    private func movieCollectionLayout() {
        if let layout = mainView.movieCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset: CGFloat = 1
            let cellHeight = mainView.movieCollection.frame.height
            layout.itemSize = CGSize(width: cellHeight / 12 * 7, height: cellHeight)
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
            layout.invalidateLayout()
        }
        
    }

    @objc func xButtonTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.searchedTerm.remove(at: sender.tag)
        //mainView.searchedWords.reloadData()
        //switchSearchedTermView()

    }
    @objc func updateMoviebox() {

        mainView.profileView.movieboxButton.setButtonTitle(title: "\(UserDefaultsManager.shared.like.count) 개의 무비박스 보관중", color: UIColor.white, size: 16, weight: .bold)
    }
}

extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0 : return UserDefaultsManager.shared.searchedTerm.count
        default: return viewModel.movieList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchWordsCollectionViewCell.id, for: indexPath) as? SearchWordsCollectionViewCell else {return UICollectionViewCell()}
            cell.configureData(item: indexPath.item)
            cell.xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
            return cell
        default :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMoviesCollectionViewCell.id, for: indexPath) as? TodayMoviesCollectionViewCell else {return UICollectionViewCell()}
            cell.configureData(item: viewModel.movieList.value[indexPath.item])
            cell.heartButton.addTarget(self, action: #selector(updateMoviebox), for: .touchUpInside)
            return cell
            
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0 :
            let vc = SearchViewController()
            let word = UserDefaultsManager.shared.searchedTerm[indexPath.item]
            vc.inputText = word
            vc.mainView.searchBar.text = word
            navigationController?.pushViewController(vc, animated: true)
        default :
            let vc = MovieDetailViewController()
            let item = viewModel.movieList.value[indexPath.item]
            vc.movieId = item.id
            vc.releaseDate = item.release_date
            vc.rate = String(item.vote_average ?? 0.0)
            vc.movieTitle = item.title
            vc.synopsis = item.overview
            vc.genre = item.genre_ids

            navigationController?.pushViewController(vc, animated: true)

        }
    }

    
}


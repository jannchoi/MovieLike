//
//  CinemaViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class CinemaViewController: UIViewController {
    let mainView = CinemaView()
    var trendMovieList = [MovieDetail]()
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarDesign()
        mainView.searchedWords.delegate = self
        mainView.searchedWords.dataSource = self


        mainView.movieCollection.delegate = self
        mainView.movieCollection.dataSource = self
        
        mainView.movieboxButton.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        mainView.grayBackView.addGestureRecognizer(tapGesture)
        mainView.deleteButton.addTarget(self, action: #selector(resetSearchedTerm), for: .touchUpInside)
        loadData()
    }
    @objc func resetSearchedTerm() {
        UserDefaultsManager.shared.searchedTerm.removeAll()
        mainView.searchedWords.reloadData()
    }

    @objc func profileViewTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigationBarDesign() {
        self.tabBarController?.navigationItem.title = "오늘의 영화"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .MyBlue
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfile()
        mainView.searchedWords.reloadData()
        if UserDefaultsManager.shared.searchedTerm.isEmpty {
            mainView.noSearchedWord.isHidden = false
        } else {
            mainView.noSearchedWord.isHidden = true
        }
    }
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        vc.searchButtonClicked = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.callRequst(api: .todayMovie, model: TrendMovie.self) { value in
            self.trendMovieList = value.results
            group.leave()
        } failHandler: {
            print("fail")
            group.leave()
        }
        group.notify(queue: .main) {
            self.mainView.movieCollection.reloadData()
        }

    }
    func setProfile() {
        let img = UserDefaultsManager.shared.profileImage
        mainView.profileImage.image = UIImage(named: "profile_\(img)")
        mainView.nickname.text = UserDefaultsManager.shared.nickname
        mainView.dateLabel.text = UserDefaultsManager.shared.signDate + " 가입"
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
        movieCollectionLayout()
        
    }
    
    func movieCollectionLayout() {
        if let layout = mainView.movieCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset: CGFloat = 1
            let cellHeight = mainView.movieCollection.frame.height
            layout.itemSize = CGSize(width: cellHeight / 12 * 7, height: cellHeight)
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
            layout.invalidateLayout()
        }
    }

    @objc func xButtonTapped(_ sender: UIButton) {
        print(#function,UserDefaultsManager.shared.searchedTerm.count ,sender.tag)
        UserDefaultsManager.shared.searchedTerm.remove(at: sender.tag)
        mainView.searchedWords.reloadData()

    }
}

extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0 : return UserDefaultsManager.shared.searchedTerm.count
        default: return trendMovieList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0 : let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchWordsCollectionViewCell.id, for: indexPath) as! SearchWordsCollectionViewCell
            cell.configureData(item: indexPath.item)
            cell.xButton.tag = indexPath.item
            cell.xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMoviesCollectionViewCell.id, for: indexPath) as! TodayMoviesCollectionViewCell
            cell.configureData(item: trendMovieList[indexPath.item])
            return cell
            
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0 :
            let vc = SearchViewController()
            vc.inputText = UserDefaultsManager.shared.searchedTerm[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        default :
            let vc = MovieDetailViewController()
            let item = trendMovieList[indexPath.item]
            vc.movieId = item.id
            vc.releaseDate = item.release_date
            vc.rate = String(item.vote_average)
            vc.movieTitle = item.title
            vc.synopsis = item.overview
            vc.genre = item.genre_ids
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

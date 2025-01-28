//
//  MovieDetailViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit


class MovieDetailViewController: UIViewController {
    let mainView = MovieDetailView()
    var movieId : Int?

    var releaseDate : String?
    var rate : String?
    var genre : [Int]?
    var movieTitle: String?
    var synopsis : String?
    var backdropImg = [FileDetail]()
    var posterImage = [FileDetail]()
    var castList = [CastDetail]()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.moreButton.addTarget(self, action: #selector(toggleSynopsis), for: .touchUpInside)
        mainView.synopsisShort.text = synopsis
        mainView.synopsisLong.text = synopsis
        
        mainView.backDropView.isPagingEnabled = true
        setDelegate()
        navigationBarDesign()
        loadData()
        setInfoView()
    }
    func navigationBarDesign() {
        navigationItem.title = movieTitle ?? "title"
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTappeed))
        
        if UserDefaultsManager.shared.like.contains(movieId!) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(heartButtonTappeed))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTappeed))
        }
        
        navigationItem.rightBarButtonItem?.tintColor = .MyBlue
    }
    @objc func heartButtonTappeed() {
        if let idx = UserDefaultsManager.shared.like.firstIndex(of: movieId!) {
            //만약에 값을 가지고 있다면, 제거, 빈 하트
            UserDefaultsManager.shared.like.remove(at: idx)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTappeed))
        } else { // 값이 없다면, 추가, 꽉찬 하트
            UserDefaultsManager.shared.like.append(movieId!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(heartButtonTappeed))
        }
    }
    func toggleLike(_ sender: UIButton) {
        
    }
    func setDelegate() {
        mainView.backDropView.delegate = self
        mainView.backDropView.dataSource = self
        mainView.castView.delegate = self
        mainView.castView.dataSource = self
        mainView.posterView.delegate = self
        mainView.posterView.dataSource = self
    }
    @objc func toggleSynopsis() {
        
        let shortHidden = mainView.synopsisShort.isHidden
        mainView.synopsisShort.isHidden = !shortHidden
        mainView.synopsisLong.isHidden = shortHidden
        
        if mainView.synopsisShort.isHidden {
            mainView.moreButton.setTitle("Hide", for: .normal)
            mainView.castLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainView.synopsisLong.snp.bottom).offset(16)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.height.equalTo(20)
            }
        } else {
            mainView.moreButton.setTitle("More", for: .normal)
            mainView.castLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainView.synopsisShort.snp.bottom).offset(16)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.height.equalTo(20)
            }
        }
        view.layoutIfNeeded()
    }
    func loadData() {
        guard let movieId else {return}
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.callRequst(api: .movieImage(id: movieId), model: MovieImage.self) { value in
            self.backdropImg = value.backdrops
            self.posterImage = value.posters
            group.leave()
        } failHandler: {
            group.leave()
        }
        group.enter()
        NetworkManager.shared.callRequst(api: .cast(id: movieId), model: MovieCredit.self) { value in
            self.castList = value.cast
            group.leave()
        } failHandler: {
            group.leave()
        }
        group.notify(queue: .main) {
            self.mainView.backDropView.reloadData()
            self.mainView.castView.reloadData()
            self.mainView.posterView.reloadData()
        }
    }
    func setInfoView() {
        let date = mainView.infoStackView.arrangedSubviews[0] as! UIButton
        date.setAttributedTitle(NSAttributedString(string: releaseDate ?? "None" + " | ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) ,NSAttributedString.Key.foregroundColor : UIColor.MyGray]), for: .normal)
        date.setImage(UIImage(systemName: "calendar"), for: .normal)
        date.tintColor = .MyGray
        date.isUserInteractionEnabled = false
        
        let tempRate = mainView.infoStackView.arrangedSubviews[1] as! UIButton
        tempRate.setAttributedTitle(NSAttributedString(string: rate ?? "Nonw" + " | ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) ,NSAttributedString.Key.foregroundColor : UIColor.MyGray]), for: .normal)
        tempRate.setImage(UIImage(systemName: "star.fill"), for: .normal)
        tempRate.tintColor = .MyGray
        tempRate.isUserInteractionEnabled = false
        
        
        let tempGenre = mainView.infoStackView.arrangedSubviews[2] as! UIButton
        
        var genretotal = [String]()

        if let genre {
            let min = min(genre.count, 5) - 1
            for i in 0...min {
                genretotal.append(GenreManager.shared.getGenre(genre[i]) ?? "")
            }
        }
        let genreStr = genretotal.joined(separator: ",")

        tempGenre.setAttributedTitle(NSAttributedString(string: genreStr, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) ,NSAttributedString.Key.foregroundColor : UIColor.MyGray]), for: .normal)
        tempGenre.setImage(UIImage(systemName: "film.fill"), for: .normal)
        tempGenre.tintColor = .MyGray
        tempGenre.isUserInteractionEnabled = false
    }
    

}
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            if backdropImg.count >= 5 {
                return 5
            } else {
                return backdropImg.count
            }
        case 1: return castList.count
        default : return posterImage.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as! BackDropCollectionViewCell
            cell.configureData(item: backdropImg[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell
            cell.configureData(item: castList[indexPath.row])

            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell
            cell.configureData(item: posterImage[indexPath.row])
            
            return cell
        }

    }
    
    
}

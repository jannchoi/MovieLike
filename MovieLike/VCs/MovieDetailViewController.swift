//
//  MovieDetailViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let mainView = MovieDetailView()
    
    let viewModel = MovieDetailViewModel()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.moreButton.addTarget(self, action: #selector(toggleSynopsis), for: .touchUpInside)
        mainView.backDropView.showsHorizontalScrollIndicator = false
        mainView.backDropView.isPagingEnabled = true
        setDelegate()
        navigationBarDesign()
        bindData()

        
    }
    private func bindData() {
        viewModel.input.synopsis.bind {[weak self] text in // 시놉시스
            self?.mainView.synopsisShort.text = text
            self?.mainView.synopsisLong.text = text
        }
        viewModel.input.movieTitle.bind {[weak self] title in // 영화 제목이 결정되면 상단 바 제목 결정
            self?.tabBarController?.navigationItem.title = title
        }
        viewModel.output.outputMovieId.bind {[weak self] id in // 영화 id가 결정되면 좋아요 상태에 따라 UI변경
            guard let id else {return}
            self?.tabBarController?.navigationItem.setHeartButton(id)
        }
        viewModel.output.backdropImage.lazyBind {[weak self] _ in // 백드롭리스트
            self?.mainView.backDropView.reloadData()
        }
        viewModel.output.posterImage.lazyBind {[weak self] _ in // 포스터리스트
            self?.mainView.posterView.reloadData()
        }
        viewModel.output.errorMessage.lazyBind {[weak self] message in
            self?.showAlert(title: "ERROR", text: message, button: nil)
        }
        viewModel.output.castList.lazyBind {[weak self] _ in // 캐스트리스트
            self?.mainView.castView.reloadData()
        }
        setInfoLabel()
    }
    private func setInfoLabel() {
        viewModel.input.releaseDate.bind {[weak self] releasedate in
            guard let date = self?.mainView.infoStackView.arrangedSubviews[0] as? UIButton else {return}
            date.setButtonTitle(title: (releasedate) + "   | ", color: UIColor.MyGray, size: 12)
            date.setImage(UIImage(systemName: "calendar"), for: .normal)
            date.tintColor = .MyGray
            date.isUserInteractionEnabled = false
        }
        viewModel.input.rate.bind {[weak self] rate in
            guard let tempRate = self?.mainView.infoStackView.arrangedSubviews[1] as? UIButton else {return}
            tempRate.setButtonTitle(title: (rate) + "   | ", color: UIColor.MyGray, size: 12)
            tempRate.setImage(UIImage(systemName: "star.fill"), for: .normal)
            tempRate.tintColor = .MyGray
            tempRate.isUserInteractionEnabled = false
        }
        viewModel.input.genre.bind {[weak self] list in
            guard let tempGenre = self?.mainView.infoStackView.arrangedSubviews[2] as? UIButton else {return}
            var genretotal = [String]()

            if let list, list.count > 0 {
                let min = min(list.count, 2) - 1
                for i in 0...min {
                    genretotal.append(GenreManager.shared.getGenre(list[i]) ?? "")
                }
            }
            let genreStr = genretotal.joined(separator: ",")
            tempGenre.setButtonTitle(title: genreStr, color: UIColor.MyGray, size: 12)
            tempGenre.setImage(UIImage(systemName: "film.fill"), for: .normal)
            tempGenre.tintColor = .MyGray
            tempGenre.isUserInteractionEnabled = false
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func setPager() {
        mainView.pager.numberOfPages = min(viewModel.output.backdropImage.value.count, 5)
        mainView.pager.currentPage = 0
        
        mainView.pager.pageIndicatorTintColor = .MyGray
        mainView.pager.currentPageIndicatorTintColor = .MylightGray
        mainView.pager.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        DispatchQueue.main.async {
            self.mainView.updateViewLayout()
            self.setPager()
        }
    }
    @objc func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        mainView.backDropView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func navigationBarDesign() {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = .MyBlue
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .MyBlue
    }

    private func setDelegate() {
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
            mainView.moreButton.setButtonTitle(title: "Hide", color: .MyBlue, size: 14, weight: .bold)
            mainView.castLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainView.synopsisLong.snp.bottom).offset(16)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.height.equalTo(20)
            }
        } else {
            mainView.moreButton.setButtonTitle(title: "More", color: .MyBlue, size: 14, weight: .bold)
            mainView.castLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainView.synopsisShort.snp.bottom).offset(16)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
                make.height.equalTo(20)
            }
        }
        view.layoutIfNeeded()
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            if viewModel.output.backdropImage.value.count >= 5 {
                return 5
            } else {
                return viewModel.output.backdropImage.value.count
            }
        case 1: return viewModel.output.castList.value.count
        default : return viewModel.output.posterImage.value.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else {return UICollectionViewCell()}
            cell.configureData(item: viewModel.output.backdropImage.value[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell else {return UICollectionViewCell()}
            cell.configureData(item: viewModel.output.castList.value[indexPath.row])

            return cell
        default :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else {return UICollectionViewCell()}
            
            cell.configureData(item: viewModel.output.posterImage.value[indexPath.row])
            
            return cell
        }
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainView.backDropView {
            let width = scrollView.bounds.size.width
            let x = scrollView.contentOffset.x + (width / 2)
            let newPage = Int(x / width)
            
            if mainView.pager.currentPage != newPage {
                mainView.pager.currentPage = newPage
            }
        }
    }
}

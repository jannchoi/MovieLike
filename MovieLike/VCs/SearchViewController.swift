//
//  SearchViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
import SkeletonView

final class SearchViewController: UIViewController {

    let mainView = SearchView()
    let viewModel = SearchViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        
        mainView.tableView.isSkeletonable = true
        
        bindData()

    }
    
    private func bindData() {

        viewModel.output.movieList.lazyBind { _ in
            if self.viewModel.isResultEmpty {
                self.mainView.noSearchLabel.isHidden = false
                self.mainView.tableView.isHidden = true
                return
            }
            else {
                self.mainView.noSearchLabel.isHidden = true
                self.mainView.tableView.isHidden = false
            }
            self.mainView.tableView.showSkeleton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.mainView.tableView.reloadData()
                self.mainView.tableView.hideSkeleton()
            }
            
        }
        viewModel.output.errorMessage.lazyBind { message in
            guard let message else {return}
            self.showAlert(title: "Error", text: message, button: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.output.isFromSearchButton.bind { Bool in
            self.setFirstUI(bool: Bool)
        }
        navigationBarDesign()
        mainView.tableView.reloadData()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.input.fromSearchButton.value = false
    }
    private func navigationBarDesign() {
        self.tabBarController?.navigationItem.title = "영화 검색"
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.leftBarButtonItem?.tintColor = .MyBlue
        
    }
    private func setDelegate() {
        mainView.searchBar.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateViewLayout()
    }
    private func setFirstUI(bool: Bool) {
        if bool {
            mainView.searchBar.becomeFirstResponder()
            mainView.tableView.isHidden = true
            mainView.noSearchLabel.isHidden = true
        }
        else {
            mainView.tableView.isHidden = false
        }
    }
    
}
extension SearchViewController: SkeletonTableViewDataSource{
    func numSections(in collectionSkeletonView: UITableView) -> Int  {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.movieList.value.count
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchTableViewCell.id
    }
}
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.input.prefetchTrigger.value = indexPaths
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchedTerm.value = searchBar.text

        view.endEditing(true)
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.movieList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as? SearchTableViewCell else {return UITableViewCell()}
        if let inputTxt = mainView.searchBar.text {
            cell.configureData(item: viewModel.output.movieList.value[indexPath.row], txt: inputTxt)
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        let item = viewModel.output.movieList.value[indexPath.row]
        vc.viewModel.input.movieId.value = item.id
        vc.viewModel.input.releaseDate.value = item.release_date ?? "None"
        vc.viewModel.input.rate.value = String(item.vote_average ?? 0.0)
        vc.viewModel.input.movieTitle.value = item.title
        vc.viewModel.input.synopsis.value = item.overview ?? "None"
        vc.viewModel.input.genre.value = item.genre_ids
        navigationController?.pushViewController(vc, animated: true)
    }
}

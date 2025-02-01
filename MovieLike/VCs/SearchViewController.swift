//
//  SearchViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit

final class SearchViewController: UIViewController {

    let mainView = SearchView()
    var inputText : String?
    var searchButtonClicked = false
    private var page: Int = 1
    private var movieList = [MovieDetail]()
    private var isEnd = false
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        navigationBarDesign()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFirstUI()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchButtonClicked = false
    }
    private func navigationBarDesign() {
        navigationItem.setBarTitleView(title: "영화 검색")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .MyBlue
        
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
    private func setFirstUI() {
        if searchButtonClicked{
            mainView.searchBar.becomeFirstResponder()
            mainView.tableView.isHidden = true
            mainView.noSearchLabel.isHidden = true
        }
        else {
            mainView.tableView.isHidden = false
            loadData()
        }
    }
    private func loadData() {
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.callRequst(api: .searchMovie(query: inputText ?? "", page: page), model: SearchMovie.self, vc: self) { value in
            
            if self.page > value.total_pages {
                self.isEnd = true
                group.leave()
                return
            }
            if value.results.isEmpty {
                self.mainView.noSearchLabel.isHidden = false
                self.mainView.tableView.isHidden = true
            }
            else {
                self.mainView.noSearchLabel.isHidden = true
            }
            
            if self.page == 1{
                self.movieList = value.results
            } else {
                self.movieList.append(contentsOf: value.results)
            }
            group.leave()
            
        }
        group.notify(queue: .main) {
            self.mainView.tableView.reloadData()
        }
    }
}
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            if movieList.count - 4 <= item.row && isEnd == false {
                page += 1
                loadData()
            }
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        inputText = searchBar.text ?? ""
        inputText = inputText?.trimmingCharacters(in: .whitespacesAndNewlines)
        page = 1
        movieList.removeAll()
        mainView.tableView.isHidden = false
        if !UserDefaultsManager.shared.searchedTerm.contains(inputText!) {
            UserDefaultsManager.shared.searchedTerm.insert(inputText!, at: 0)
        }
        loadData()
        view.endEditing(true)
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as? SearchTableViewCell else {return UITableViewCell()}
        if let inputTxt = mainView.searchBar.text {
            cell.configureData(item: movieList[indexPath.row], txt: inputTxt)
        }

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        let item = movieList[indexPath.row]
        vc.movieId = item.id
        vc.releaseDate = item.release_date
        vc.rate = String(item.vote_average ?? 0.0)
        vc.movieTitle = item.title
        vc.synopsis = item.overview
        vc.genre = item.genre_ids
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  SearchViewController.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit

class SearchViewController: UIViewController {

    let mainView = SearchView()
    var inputText : String?
    var searchButtonClicked = false
    var page: Int = 1
    var movieList = [MovieDetail]()
    var isEnd = false
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchBar.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
        
        setFirstUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.searchBar.layer.cornerRadius = 5
        mainView.searchBar.clipsToBounds = true
    }
    func setFirstUI() {
        if searchButtonClicked{
            mainView.searchBar.resignFirstResponder()
            mainView.tableView.isHidden = true
            mainView.noSearchLabel.isHidden = true
        }
        else {
            mainView.tableView.isHidden = false
            loadData()
        }
    }
    func loadData() {
        NetworkManager.shared.callRequst(api: .searchMovie(query: inputText ?? "", page: page), model: SearchMovie.self) { value in
            if value.results.isEmpty {
                self.mainView.noSearchLabel.isHidden = false
                self.mainView.tableView.isHidden = true
            }
            else {
                self.mainView.noSearchLabel.isHidden = true
            }
            if self.page == 1{
                self.movieList = value.results
                //self.mainView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            } else {
                self.movieList.append(contentsOf: value.results)
            }
            if self.page > value.total_pages {
                self.isEnd = true
            }
            self.mainView.tableView.reloadData()
            
        } failHandler: {
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as! SearchTableViewCell
        
        cell.configureData(item: movieList[indexPath.row])
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
        vc.rate = String(item.vote_average)
        vc.movieTitle = item.title
        vc.synopsis = item.overview
        vc.genre = item.genre_ids
        navigationController?.pushViewController(vc, animated: true)
    }
}

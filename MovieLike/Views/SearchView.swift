//
//  SearchView.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
import SnapKit

class SearchView: BaseView {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let noSearchLabel = UILabel()
    
    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(noSearchLabel)
        
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        noSearchLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = .black
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .darkGray
        searchBar.backgroundColor = .black
        noSearchLabel.labelDesign(inputText: "원하는 검색 결과를 찾지 못했습니다.", size: 12, color: .MyGray)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        tableView.backgroundColor = .black
        
    }
}

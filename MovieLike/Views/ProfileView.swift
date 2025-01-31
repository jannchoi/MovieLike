//
//  ProfileView.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    let profileView = ProfileBaseView()
    let tableView = UITableView()
    
    override func configureHierachy() {
        addSubview(profileView)
        addSubview(tableView)
    }
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(136)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
    }
}

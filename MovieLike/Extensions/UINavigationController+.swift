//
//  UINavigationController+.swift
//  MovieLike
//
//  Created by 최정안 on 1/31/25.
//

import UIKit
extension UINavigationController {
    func setBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    

}
extension UINavigationItem {
    func setBarTitleView(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        self.titleView = titleLabel
    }
    
    @objc func heartButtonTapped(_ sender: UIBarButtonItem) {
        var img : UIImage
        if let idx = UserDefaultsManager.shared.like.firstIndex(of: sender.tag) {
            UserDefaultsManager.shared.like.remove(at: idx)
            img = UIImage(systemName: "heart")!
        } else {
            UserDefaultsManager.shared.like.append(sender.tag)
            img = UIImage(systemName: "heart.fill")!
        }
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(heartButtonTapped))
        btn.tag = sender.tag
        self.rightBarButtonItem = btn
        self.rightBarButtonItem?.tintColor = .MyBlue
    }
    
    func setHeartButton(_ tag: Int) {
        var img : UIImage
        if UserDefaultsManager.shared.like.contains(tag) {
            img = UIImage(systemName: "heart.fill")!
        } else {
            img = UIImage(systemName: "heart")!
        }
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(heartButtonTapped))
        btn.tag = tag
        self.rightBarButtonItem = btn
        self.rightBarButtonItem?.tintColor = .MyBlue
    }
}

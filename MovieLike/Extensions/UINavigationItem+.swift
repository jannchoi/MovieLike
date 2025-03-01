//
//  UINavigationItem+.swift
//  MovieLike
//
//  Created by 최정안 on 2/1/25.
//

import UIKit

extension UINavigationItem {
    func setBarTitleView(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        self.titleView = titleLabel
    }
    
//    @objc func heartButtonTapped(_ sender: UIBarButtonItem) {
//        var img : UIImage
//        if let idx = UserDefaultsManager.like.firstIndex(of: sender.tag) {
//            UserDefaultsManager.like.remove(at: idx)
//            img = UIImage(systemName: "heart")!
//        } else {
//            UserDefaultsManager.like.append(sender.tag)
//            img = UIImage(systemName: "heart.fill")!
//        }
//        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(heartButtonTapped))
//        btn.tag = sender.tag
//        self.rightBarButtonItem = btn
//        self.rightBarButtonItem?.tintColor = .MyBlue
//    }
//    
//    func setHeartButton(_ tag: Int) {
//        var img : UIImage
//        if UserDefaultsManager.like.contains(tag) {
//            img = UIImage(systemName: "heart.fill")!
//        } else {
//            img = UIImage(systemName: "heart")!
//        }
//        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(heartButtonTapped))
//        btn.tag = tag
//        self.rightBarButtonItem = btn
//        self.rightBarButtonItem?.tintColor = .MyBlue
//    }
}

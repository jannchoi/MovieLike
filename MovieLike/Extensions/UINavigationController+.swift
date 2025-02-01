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

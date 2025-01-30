//
//  TabBarController.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        setupTabBarAppearence()
        
    }
    func configureTabBarController() {
        let firstVC = CinemaViewController()
        firstVC.tabBarItem.title = "CINEMA"
        firstVC.tabBarItem.image = UIImage(systemName: "popcorn")
        
        let secondVC = UpcomingViewController()
        secondVC.tabBarItem.title = "UPCOMMING"
        secondVC.tabBarItem.image = UIImage(systemName: "film.stack")
        
        let thirdVC = ProfileViewController()
        thirdVC.tabBarItem.title = "PROFILE"
        thirdVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
    
    func setupTabBarAppearence() {
        let appearence = UITabBarAppearance()
        appearence.stackedLayoutAppearance.selected.iconColor = .MyBlue
        appearence.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor : UIColor.MyBlue]
        
        appearence.stackedLayoutAppearance.normal.iconColor = .MyGray
        appearence.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.MyGray]
        appearence.backgroundColor = .black
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
    }
}

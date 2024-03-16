//
//  TabBarController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 23.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    let homeVC = MainPageViewController()
    let favoriteVC = FavoriteTableViewController()
    let profileVC = ProfileViewController()
    let searchVC = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        tabBar.barTintColor = UIColor(named: " #FFFFFF - #121827")
        
        homeVC.tabBarItem.image = UIImage(named: "Home")
        favoriteVC.tabBarItem.image = UIImage(named: "Favorite")
        profileVC.tabBarItem.image = UIImage(named: "Profile")
        searchVC.tabBarItem.image = UIImage(named: "Search")
        
        let VCs = [CustomNavigationController(rootViewController: homeVC),
                   CustomNavigationController(rootViewController: searchVC),
                   CustomNavigationController(rootViewController: favoriteVC),
                   CustomNavigationController(rootViewController: profileVC)]
        
        setViewControllers(VCs, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        homeVC.tabBarItem.selectedImage = UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal)
        searchVC.tabBarItem.selectedImage = UIImage(named: "SelectedSearch")!.withRenderingMode(.alwaysOriginal)
        favoriteVC.tabBarItem.selectedImage = UIImage(named:    "FavoriteSelected")!.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal)
    }
}

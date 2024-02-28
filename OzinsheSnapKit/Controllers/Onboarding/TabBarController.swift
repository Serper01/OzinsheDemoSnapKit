//
//  TabBarController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 23.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let homeVC = HomeViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        let searchVC = SearchViewController()
        
        homeVC.tabBarItem.image = UIImage(named: "Home")
        homeVC.tabBarItem.selectedImage = UIImage(named: "HomeSelected")
        
        favoriteVC.tabBarItem.image = UIImage(named: "Favorite")
        favoriteVC.tabBarItem.selectedImage = UIImage(named: "FavoriteSelected")
        
        profileVC.tabBarItem.image = UIImage(named: "Profile")
        profileVC.tabBarItem.selectedImage = UIImage(named: "ProfileSelected")
        
        searchVC.tabBarItem.image = UIImage(named: "Search")
        searchVC.tabBarItem.selectedImage = UIImage(named: "SelectedSearch")
        //дополнить
        let VCs = [UINavigationController(rootViewController: homeVC), favoriteVC, profileVC, searchVC]
        setViewControllers(VCs, animated: true)
        
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



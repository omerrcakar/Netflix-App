//
//  ViewController.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 14.10.2025.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createTabbar()
    }
    
    func createTabbar(){
        let vcFirst   = UINavigationController(rootViewController: HomeViewController())
        let vcSeconds = UINavigationController(rootViewController: UpcomingViewController())
        let vcThird   = UINavigationController(rootViewController: SearchViewController())
        let vcLast    = UINavigationController(rootViewController: DownloadViewController())
        
        // Tabbar Image
        vcFirst.tabBarItem.image   = UIImage(systemName: "house")
        vcSeconds.tabBarItem.image = UIImage(systemName: "play.circle")
        vcThird.tabBarItem.image   = UIImage(systemName: "magnifyingglass")
        vcLast.tabBarItem.image    = UIImage(systemName: "arrow.down.circle")
        
        // Tab Title
        vcFirst.title   = "Home"
        vcSeconds.title = "Coming Soon"
        vcThird.title   = "Top Search"
        vcLast.title    = "Downloads"
        
        tabBar.tintColor = .label
        
        // Set VC
        setViewControllers([vcFirst,vcSeconds,vcThird,vcLast], animated: true)
    }

}


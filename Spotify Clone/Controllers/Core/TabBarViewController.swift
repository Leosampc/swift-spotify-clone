//
//  TabBarViewController.swift
//  Spotify Clone
//
//  Created by Leonardo Cruz on 03/06/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let libraryVC = LibraryViewController()
        
        homeVC.title = "Início"
        searchVC.title = "Busca"
        libraryVC.title = "Sua Biblioteca"
        
        homeVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        libraryVC.navigationItem.largeTitleDisplayMode = .always
        
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        let searchNavigationController = UINavigationController(rootViewController: searchVC)
        let libraryNavigationController = UINavigationController(rootViewController: libraryVC)
        
        homeNavigationController.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        searchNavigationController.tabBarItem = UITabBarItem(title: "Busca", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryNavigationController.tabBarItem = UITabBarItem(title: "Sua Biblioteca", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        
        homeNavigationController.navigationBar.prefersLargeTitles = true
        searchNavigationController.navigationBar.prefersLargeTitles = true
        libraryNavigationController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([homeNavigationController, searchNavigationController, libraryNavigationController], animated: false)
    }
}

//
//  TabBarController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let storageManager = StorageManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchVC = SearchViewController(storageManager: storageManager)
        let historyVC = HistoryViewController(storageManager: storageManager)
        
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        let viewControllerList = [searchVC, historyVC]
        viewControllers = viewControllerList
    }
}


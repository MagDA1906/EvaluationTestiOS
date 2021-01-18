//
//  TabBarController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchVC = SearchViewController()
        let historyVC = HistoryViewController()
        
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        let viewCintrollerList = [searchVC, historyVC]
        viewControllers = viewCintrollerList
    }
}


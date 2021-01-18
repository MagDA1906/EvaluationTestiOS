//
//  HistoryViewController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var tableView: UITableView!
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("HistoryViewController")
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
}

extension HistoryViewController {
    
    // Create and confugure TableView
    func configureTableView() {
        
        tableView = UITableView()
        
        tableView.dataSource = self
    
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseId)
        
        view.addSubview(tableView)
        
        tableView.tableFooterView = footerView
        tableView.frame = view.frame
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        // tableView constraints
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    // Create SearchTableViewCell
    func searchCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseId, for: indexPath)
        
        guard let searchCell = cell as? SearchTableViewCell else {
            return cell
        }
        
        let realmArray = try! Realm().objects(RealmModel.self)
        let count = realmArray.count - 1
        let search = realmArray[count - indexPath.row]
        searchCell.searchNameLabel.text = search.searchingText
        
        return searchCell
    }
}

// MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realmModels = try! Realm().objects(RealmModel.self)
        return realmModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return searchCellForIndexPath(indexPath)
    }
}

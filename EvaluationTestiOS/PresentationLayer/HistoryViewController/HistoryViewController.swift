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
    
//    private var tableView: UITableView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var backView: UIImageView!
    private let storageManager: StorageManagerProtocol
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // MARK: - Life Cycle
    
    public init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureClearButton()
    }
}

extension HistoryViewController {
    
    // Configure NavigationItem
    func configureNavigationItem() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Configure ClearButton
    func configureClearButton() {
        clearButton.layer.cornerRadius = 8
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = UIColor.white.cgColor
        clearButton.backgroundColor = .black
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        
        clearButton.addTarget(self, action: #selector(actionClearButton), for: .touchUpInside)
    }
    
    @objc func actionClearButton(sender: UIButton) {
        let realm = try! Realm()
        try! realm.write() {

            realm.deleteAll()
            tableView.reloadData()
        }
    }
    
    // Create and confugure TableView
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseId)
        
        self.tableView.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = footerView
        tableView.frame = view.frame
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
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

// MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let text = (cell as! SearchTableViewCell).searchNameLabel.text else { return }
        let vc = AlbumsViewController(storageManager: self.storageManager, searchingText: text)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  AlbumDetailViewController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 17.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Initialization
    
    private var albumId: Int
    private let networkManager = NetworkManager()
    private let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol, albumId: Int) {
        self.storageManager = storageManager
        self.albumId = albumId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private var tableView: UITableView!
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTracks()
        configureNavigationItem()
        configureTableView()
    }
}

// MARK: - Private Functions

private extension AlbumDetailViewController {
    
    // Create HeaderAlbumTableViewCell
    func headerCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderAlbumTableViewCell.nibName, for: indexPath)
        
        guard let headerCell = cell as? HeaderAlbumTableViewCell else {
            return cell
        }
        
        guard let album = storageManager.getModelById(albumId) else {
            return cell
        }
        let stringFromDate = storageManager.getDateFrom(album) // Conversed Date to String and set to header cell property
        headerCell.configureSelfUsingModel(album, stringFromDate)
        return headerCell
    }
    
    // Create TrackTableViewCell
    func trackCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseId, for: indexPath)
        
        guard let trackCell = cell as? TrackTableViewCell else {
            return cell
        }
        
        let track = storageManager.getSavedRequestData(description: .tracks, for: indexPath) as Track
        trackCell.trackNameLabel.text = track.trackName
        
        return trackCell
    }
    
    // Fetch tracks for current album
    func fetchTracks() {
        storageManager.removeLastRequestData(description: .tracks)
        networkManager.getAlbumTracks(albumId: albumId) { (tracks, error) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
            
            if let tracks = tracks {
                if tracks.count != 0 {
                    self.storageManager.save(description: .tracks, data: tracks)
                    
                    DispatchQueue.main.async {
                        dump(tracks)
                        self.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            }
        }
    }
    
    // Show Alert if tracks not found
    func showAlert() {
        let notFoundAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        let alert = UIAlertController(title: "Tracks not found",
                                      message: "No tracks results were found for this album.",
                                      preferredStyle: .alert)
        alert.addAction(notFoundAction)
        self.present(alert, animated: true)
    }
    
    // Create and confugure TableView
    func configureTableView() {
        
        tableView = UITableView()
        
        tableView.dataSource = self
        
        let headerCellReuseId = HeaderAlbumTableViewCell.nibName
        let headerCellNib = UINib(nibName: headerCellReuseId, bundle: nil)
        
        tableView.register(headerCellNib, forCellReuseIdentifier: headerCellReuseId)
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.reuseId)
        
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
    
    // Configure NavigationItem
    func configureNavigationItem() {
        navigationItem.title = "Album detail"
    }
}

// MARK: - UITableViewDataSource

extension AlbumDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageManager.getNumberOfElementsIn(description: .tracks) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return headerCellForIndexPath(indexPath)
        } else {
            return trackCellForIndexPath(indexPath)
        }
        
    }
}


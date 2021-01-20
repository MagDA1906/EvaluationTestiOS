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
    private var spinner: UIActivityIndicatorView!
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let backView: UIImageView = {
        let imageName = "Background.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return imageView
    }()
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackView()
        configureNavigationItem()
        configureTableView()
        configureSpinner()
        fetchTracks()
    }
}

// MARK: - Private Functions

private extension AlbumDetailViewController {
    
    func configureBackView() {
        
        backView.frame = view.frame
        view.addSubview(backView)
        
        backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
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
        didStartSpinner()
        storageManager.removeLastRequestData(description: .tracks)
        networkManager.getAlbumTracks(albumId: albumId) { (tracks, error) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.showAlert()
                    self.didStopSpinner()
                }
            }
            
            if let tracks = tracks {
                if tracks.count != 0 {
                    self.storageManager.save(description: .tracks, data: tracks)
                    
                    DispatchQueue.main.async {
                        dump(tracks)
                        self.tableView.reloadData()
                        self.didStopSpinner()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert()
                        self.didStopSpinner()
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
        
        self.tableView.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        
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
    
    // configure spinner
    func configureSpinner() {
        
        spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = #colorLiteral(red: 0.70342803, green: 0.9250234962, blue: 0.9283149838, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(spinner)


        // spinner constraints
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
    
    func didStartSpinner() {
        
        spinner.startAnimating()
        self.view.bringSubviewToFront(spinner)
    }
    
    func didStopSpinner() {
        
        spinner.stopAnimating()
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


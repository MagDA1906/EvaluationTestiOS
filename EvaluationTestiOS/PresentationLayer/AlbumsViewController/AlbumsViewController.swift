//
//  AlbumsViewController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager()
    private let storageManager: StorageManagerProtocol
    private let searchingText: String
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    public init(storageManager: StorageManagerProtocol, searchingText: String) {
        self.storageManager = storageManager
        self.searchingText = searchingText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAlbumsUsing(searchingText)
        cofigureNavigationItem()
        configureCollectionView()
    }
}

private extension AlbumsViewController {
    
    // Configure NavigationItem
    func cofigureNavigationItem() {
        navigationItem.title = "Albums"
    }
    
    // Configure CollectionView
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.9019607843, blue: 0.937254902, alpha: 1)
        
        let albumCellReuseID = AlbumsCollectionViewCell.nibName
        let albumCellNib = UINib(nibName: albumCellReuseID, bundle: nil)
        
        collectionView.register(albumCellNib, forCellWithReuseIdentifier: albumCellReuseID)
    }
    
    // MARK: - Create AlbumCollectionViewCell
    
    func albumCellForIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumsCollectionViewCell.nibName, for: indexPath)
        
        guard let albumCell = cell as? AlbumsCollectionViewCell else {
            return cell
        }
        
        let album = storageManager.getSavedRequestData(description: .albums, for: indexPath) as Album
        albumCell.configureSelfUsingModel(album)
        
        return albumCell
    }
    
    // Fetch albums using text from SearchBar
    func fetchAlbumsUsing(_ text: String) {
        storageManager.removeLastRequestData(description: .albums)
        // TODO: move paginationOffset in to calling method
        let paginationOffset = 0
        
        networkManager.searchAlbums(searchingString: text, limit: 10, offset: paginationOffset) { (albums, error) in
            
            if let error = error {
                print(error)
                
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
            
            if let albums = albums {
                if albums.count != 0 {
                    self.storageManager.save(description: .albums, data: albums)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            }
        }
    }
    
    // Show Alert if albums not found
    func showAlert() {
        let notFoundAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            print("Action Alert!")
            self.navigationController?.popViewController(animated: true)
        }

        let alert = UIAlertController(title: "Albums not found",
                                      message: "No results were found for your search. Try changing the query text in the search bar.",
                                      preferredStyle: .alert)
        alert.addAction(notFoundAction)
        self.present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AlbumsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let album = storageManager.getSavedRequestData(description: .albums, for: indexPath) as Album
        
        // Create item animation for transition to AlbumDetailViewController
        if let item = collectionView.cellForItem(at: indexPath) as? AlbumsCollectionViewCell {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                item.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { (finished) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    item.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (finished) in
                    let vc = AlbumDetailViewController(storageManager: self.storageManager, albumId: album.collectionId)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AlbumsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storageManager.getNumberOfElementsIn(description: .albums)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return albumCellForIndexPath(indexPath)
    }
    
}

//
//  SearchViewController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    // MARK: - Private properties
//    private var timer: Timer?
    private let storageManager: StorageManagerProtocol
    
    private enum State {
        
        case viewed
        case unViewed
        
        var change: State {
            switch self {
            case .viewed:
                return .unViewed
            case .unViewed:
                return .viewed
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    
    private var state: State = .unViewed

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
        
        hideNavigationBar()
        animateMainTitleLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let realm = try! Realm()
//        try! realm.write() {
//
//            realm.deleteAll()
//        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        configureSearchBar()
        configureMainTitleLabel()
    }
}

// MARK: - Private Functions

private extension SearchViewController {
    
    // Configure infoLabel
    func configureMainTitleLabel() {
        mainTitleLabel.alpha = 0.0
    }
    
    // Animate infoLabel
    func animateMainTitleLabel() {
        
        if state == .unViewed {
            UIView.animate(withDuration: 0.2, delay: 1.0, options: .curveEaseInOut, animations: {
                self.mainTitleLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.mainTitleLabel.alpha = 0.5
            }) { (finished) in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.mainTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.mainTitleLabel.alpha = 1.0
                }, completion: { (finished) in
                    print("Animation finished")
                    self.state = self.state.change
                })
            }
        }
    }
    
    // Configure SearBar
    func configureSearchBar() {
        
        searchBar.delegate = self
        
        searchBar.showsCancelButton = false
        searchBar.searchTextField.backgroundColor = .white
    }
    
    // Configure NavigationItem
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Control timer
    // INFO: - It does not work correctly when erase a string of two characters in the SearchBar. The timer actually works on the last erased character, while the string in the SearchBar is completely erased. Instead of this function, we use Done button for starting search.
//    func startTimerWith(_ searchingString: String) {
//        if timer == nil {
//            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
//                let vc = AlbumsViewController(storageManager: self.storageManager, searchingText: searchingString)
//                self.navigationController?.pushViewController(vc, animated: true)
//                print("START TIMER!")
//                timer.invalidate()
//            })
//        } else {
//            timer!.invalidate()
//            timer = nil
//        }
//    }
//
//    func stopTimer() {
//        if timer != nil {
//            timer?.invalidate()
//            timer = nil
//        }
//    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchingString = searchBar.text else { return }
    
        if searchingString != "" {
            let realm = try! Realm()
            let realmArray = realm.objects(RealmModel.self)
            if realmArray.count > 0 {
                let lastSearchString = realmArray[realmArray.count - 1]
                if lastSearchString.searchingText != searchingString {
                    try! realm.write() {
                        let rModel = RealmModel()
                        rModel.searchingText = searchingString
                        realm.add(rModel)
                    }
                }
            } else {
                try! realm.write() {
                    let rModel = RealmModel()
                    rModel.searchingText = searchingString
                    realm.add(rModel)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.count > 0 {
//            let newSearchString = searchText.replacingOccurrences(of: " ", with: "+")
//            stopTimer()
//            startTimerWith(newSearchString)
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchBarText = searchBar.text {
            if searchBarText.count > 0 {
                let vc = AlbumsViewController(storageManager: self.storageManager, searchingText: searchBarText)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        searchBar.resignFirstResponder()
    }
}

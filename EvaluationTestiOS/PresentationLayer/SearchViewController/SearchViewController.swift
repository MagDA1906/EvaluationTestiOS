//
//  SearchViewController.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Private properties
    private var timer: Timer?
    private let storageManager = StorageManager()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        self.title = "Search"
        
        configureSearchBar()
    }
}

// MARK: - Private Functions

private extension SearchViewController {
    
    // Configure SearBar
    func configureSearchBar() {
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.barTintColor = UIColor.yellow
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
        // TODO: - Pass text to controller and save to database
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

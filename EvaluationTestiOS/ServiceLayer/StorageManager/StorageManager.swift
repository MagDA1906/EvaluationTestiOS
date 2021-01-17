//
//  StorageManager.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

public class StorageManager: StorageManagerProtocol {
    
    var albumsArray = [Album]()
    var tracksArray = [Track]()
    
    func save<T>(description: FetchingDataType, data: [T]) {
        
        switch description {
        case .albums:
            albumsArray = (data as! [Album]).sorted(by: { $0 < $1 })
        case .tracks:
            if data.count > 0 {
                tracksArray = data as! [Track]
                tracksArray.remove(at: 0)
            }
        }
    }
    
    func removeLastRequestData(description: FetchingDataType) {
        
        switch description {
        case .albums:
            albumsArray.removeAll()
        case .tracks:
            tracksArray.removeAll()
        }
    }
    
    func getSavedRequestData<T>(description: FetchingDataType, for indexPath: IndexPath) -> T {
    
        switch description {
        case .albums:
            return albumsArray[indexPath.row] as! T
        case .tracks:
            if tracksArray.count > 0 {
                return tracksArray[indexPath.row - 1] as! T
            }
            return tracksArray[indexPath.row] as! T
        }
    }
    
    func getNumberOfElementsIn(description: FetchingDataType) -> Int {
        
        switch description {
        case .albums:
            return albumsArray.count
        case .tracks:
            return tracksArray.count
        }
    }
    
    // Get model by album ID for present in AlbumDetailViewController
    func getModelById(_ id: Int) -> Album? {
        
        for album in albumsArray {
            if id == album.collectionId {
                return album
            }
        }
        return nil
    }
    
    // Convert date with format: "yyyy-MM-dEEEEEhh:mm:ssZZZ" to "MM dd yyyy"
    func getDateFrom(_ model: Album) -> String {
        
        let dateString = model.releaseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dEEEEEhh:mm:ssZZZ"
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM dd yyyy"
        return dateFormatter.string(from: dateObj!)
    }

}

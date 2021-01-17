//
//  StorageManagerProtocol.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

enum FetchingDataType {
    case albums
    case tracks
}

protocol StorageManagerProtocol: class {
    
    // save request data to array
    func save<T>(description: FetchingDataType, data: [T])
    // remove last request data
    func removeLastRequestData(description: FetchingDataType)
    // get saved request data for index path
    func getSavedRequestData<T>(description: FetchingDataType, for indexPath: IndexPath) -> T
    // get number of elements
    func getNumberOfElementsIn(description: FetchingDataType) -> Int
    // get album ID for load tracks
    func getModelById(_ id: Int) -> Album?
    // get date from album model
    func getDateFrom(_ model: Album) -> String
}

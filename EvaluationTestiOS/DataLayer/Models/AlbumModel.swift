//
//  AlbumModel.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

struct AlbumApiResponse: Codable {
    let results: [Album]
}

struct Album: Codable {
    let artistId: Int
    let collectionId: Int
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewUrl: String
    let collectionViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let trackCount: Int
    let copyright: String
    let releaseDate: String
    let country: String
    let primaryGenreName: String
}

// Protocol Comparable and Equatable

extension Album: Comparable {
    static func < (lhs: Album, rhs: Album) -> Bool {
        return lhs.collectionName < rhs.collectionName
    }
    
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.collectionName == rhs.collectionName
    }
}

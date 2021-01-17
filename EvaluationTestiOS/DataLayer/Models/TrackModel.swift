//
//  TrackModel.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

struct TrackApiModel: Codable {
    let results: [Track]
}

struct Track: Codable {
    let artistName: String
    let collectionName: String
    let trackName: String?
}

//
//  EvaluationAPI.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

public enum EvaluationApi {
    case searchingAlbums(searchingString: String, limit: Int, offset: Int)
    case albumTracks(albumId: Int)
}

extension EvaluationApi: EndPointType {
    
    // Base URL of Itunes API
    var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com/") else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    // Create path for search albums or curent albums tracks
    var path: String {
        switch self {
        case .searchingAlbums: return "search"
        case .albumTracks: return "lookup"
        }
    }
    
    // Choose HTTP method
    var httpMethod: HTTPMethod {
        return .get
    }
    
    // Create task using parameters
    var task: HTTPTask {
        switch self {
        case .searchingAlbums(let searchingString, let limit, let offset):
            return .requestParameters(bodyParameters: nil, urlParameters: ["term": searchingString, "country": "RU", "media": "music", "entity": "album", "limit": limit, "offset": offset])
        case .albumTracks(let albumId):
            return .requestParameters(bodyParameters: nil, urlParameters: ["id": albumId, "entity": "song"])
        }
    }
    // Headers
    var headers: HTTPHeaders? {
        return nil
    }
}

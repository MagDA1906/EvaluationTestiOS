//
//  NetworkManager.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    
    private let router = Router<EvaluationApi>()
    
    // Fetch albums using parameters
    
    func searchAlbums(searchingString: String, limit: Int, offset: Int, completion: @escaping (_ albums: [Album]?, _ error: String?)->()) {
        router.request(.searchingAlbums(searchingString: searchingString, limit: limit, offset: offset)) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(AlbumApiResponse.self, from: responseData)
                        dump(apiResponse)
                        completion(apiResponse.results, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    // Canceled searching
    func searchingCancelled() {
        router.cancel()
    }

    // Fetch tracks for current album using parameters
    func getAlbumTracks(albumId: Int, completion: @escaping (_ tracks: [Track]?, _ error: String?)->()) {
        router.request(.albumTracks(albumId: albumId)) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(TrackApiModel.self, from: responseData)
                        dump(apiResponse)
                        completion(apiResponse.results, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    // Hendle errors from API
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

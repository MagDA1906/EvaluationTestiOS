//
//  HTTPMethod.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

// HTTP methods
public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

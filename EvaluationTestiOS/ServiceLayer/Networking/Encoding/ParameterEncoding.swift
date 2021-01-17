//
//  ParameterEncoding.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 16.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "parameter encoding failed."
    case missingURL = "URL is nil."
}

// Encode parameters

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

//
//  NetworkError.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case error(String)
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .badUrl:
            return "Url is not correct"
        case .error(let value):
            return value
        }
    }
}

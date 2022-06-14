//
//  Endpoint.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var version: String { get }
    var httpMethod: HttpMethod { get }
    var route: String { get }
}

extension Endpoint {
    var base: String {
        return "https://restcountries.com"
    }
    
    var version: String {
        return "v3.1"
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var path: String {
        return "\(base)/\(version)/\(route)"
    }
    
    var url: URL? {
        return URL(string: path)
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.value
        
        return request
    }
}

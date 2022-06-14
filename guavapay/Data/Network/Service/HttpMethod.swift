//
//  HttpMethod.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

enum HttpMethod {
    case get
    
    var value: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

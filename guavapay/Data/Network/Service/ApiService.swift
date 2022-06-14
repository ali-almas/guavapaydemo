//
//  ApiService.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

final class ApiService {
    
    static let shared: ApiService = ApiService()
    
    private init() {
        
    }
    
    func task<T: Codable>(for endpoint: Endpoint, with type: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkError.error(response.description)
        }
        
        return try JSONDecoder().decode(type.self, from: data)
    }
}

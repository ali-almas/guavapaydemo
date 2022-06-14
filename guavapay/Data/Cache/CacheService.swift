//
//  CacheService.swift
//  guavapay
//
//  Created by Ali Almasli on 14.06.22.
//

import Foundation

class CacheService {
    static let shared: CacheService = CacheService()
    
    private init() {}
    
    var storedCountries: Countries?
}

//
//  ContinentsRepository.swift
//  guavapay
//
//  Created by Ali Almasli on 11.06.22.
//

import Foundation

protocol CountriesRepository {
    func countriesByContinent(for endpoint: ContinentEndpoint) async throws -> Countries
    func allCountries(for endpoint: AllCountriesEndpoint) async throws -> Countries
}

final class CountriesRepositoryImpl: CountriesRepository {
    private let apiService: ApiService
    private let cacheService: CacheService
    
    init(apiService: ApiService, cacheService: CacheService) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func countriesByContinent(for endpoint: ContinentEndpoint) async throws -> Countries {
        return try await apiService.task(for: endpoint, with: Countries.self)
    }
    
    func allCountries(for endpoint: AllCountriesEndpoint) async throws -> Countries {
        if let storedCountries = cacheService.storedCountries, !storedCountries.isEmpty {
            return storedCountries
        } else {
            let countries = try await apiService.task(for: endpoint, with: Countries.self)
            cacheService.storedCountries = countries
            return countries
        }
    }
}

//
//  SearchViewModel.swift
//  guavapay
//
//  Created by Ali Almasli on 13.06.22.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didSuccess(countries: Countries)
    func didReceiveError(error: NetworkError)
    func isLoading(value: Bool)
}

protocol SearchViewModel {
    var delegate: SearchViewModelDelegate? { get set }
    
    func updateSearch(query: String) async
}

class SearchViewModelImpl: SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    
    private var countriesRepository: CountriesRepository
    
    init(countriesRepository: CountriesRepository) {
        self.countriesRepository = countriesRepository
    }
    
    func updateSearch(query: String) async {
        delegate?.isLoading(value: true)
        
        do {
            let countries = try await fetchCountries()
            filter(countries: countries, with: query)
        } catch {
            delegate?.didReceiveError(error: .error(error.localizedDescription))
        }
        
        delegate?.isLoading(value: false)
    }
    
    func fetchCountries() async throws -> Countries {
        let endpoint = AllCountriesEndpoint()
        return try await countriesRepository.allCountries(for: endpoint)
    }
    
    func filter(countries: Countries, with query: String) {
        let filteredCountries = countries.filter { $0.name.common.lowercased().contains(query.lowercased()) }
        delegate?.didSuccess(countries: filteredCountries)
    }
}

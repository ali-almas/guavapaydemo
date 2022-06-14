//
//  CountriesViewModel.swift
//  guavapay
//
//  Created by Ali Almasli on 11.06.22.
//

import Foundation

protocol CountriesViewModelDelegate: AnyObject {
    func isLoading(value: Bool)
    func didReceiveError(error: NetworkError)
    func didReceiveSuccess(countries: Countries)
}

protocol CountriesViewModel {
    var title: String { get }
    var delegate: CountriesViewModelDelegate? { get set }
    
    func fetchCountries() async
}

class CountriesViewModelImpl: CountriesViewModel {
    weak var delegate: CountriesViewModelDelegate?

    private let continent: Continent
    private let countriesRepository: CountriesRepository
    
    init(continent: Continent, countriesRepository: CountriesRepository) {
        self.continent = continent
        self.countriesRepository = countriesRepository
    }
    
    var title: String {
        return continent.title
    }
    
    func fetchCountries() async {
        do {
            delegate?.isLoading(value: true)
            let endpoint = ContinentEndpoint(region: continent.value)
            let countries = try await countriesRepository.countriesByContinent(for: endpoint)
            delegate?.didReceiveSuccess(countries: countries)
        } catch {
            delegate?.didReceiveError(error: .error(error.localizedDescription))
        }
        
        delegate?.isLoading(value: false)
    }
}

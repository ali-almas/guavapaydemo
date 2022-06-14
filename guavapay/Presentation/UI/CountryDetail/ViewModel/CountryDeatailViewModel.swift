//
//  CountryDeatailViewModel.swift
//  guavapay
//
//  Created by Ali Almasli on 13.06.22.
//

import MapKit

@MainActor protocol CountryDetailViewModel: ObservableObject {
    var title: String { get }
    var flag: String { get }
    var currency: String { get }
    var capital: String { get }
    var languages: [String] { get }
    var region: MKCoordinateRegion { get set }
    var borderStatus: Future<Countries> { get set }
}

class CountryDetailViewModelImpl: CountryDetailViewModel {
    @Published var borderStatus: Future<Countries> = .idle
    @Published var region: MKCoordinateRegion
    
    private let country: Country
    private let countriesRepository: CountriesRepository
    
    init(country: Country, countriesRepository: CountriesRepository) {
        self.country = country
        self.countriesRepository = countriesRepository
        
        let center = CLLocationCoordinate2D(
            latitude: country.capitalInfo.latlng?.first ?? 0.0,
            longitude: country.capitalInfo.latlng?.last ?? 0.0
        )
        
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        self.region = MKCoordinateRegion(center: center, span: span)
        
        Task {
            try await fetchBorders()
        }
    }
    
    var title: String {
        return country.name.common
    }
    
    var flag: String {
        return country.flag
    }
    
    var currency: String {
        return country.fullCurrency
    }
    
    var capital: String {
        return country.capital?.first ?? "None"
    }
    
    var languages: [String] {
        return country.nathionalLanguages
    }
    
    func fetchBorders() async throws {
        borderStatus = .loading
        
        do {
            let countries = try await countriesRepository.allCountries(for: AllCountriesEndpoint())
            let borders = country.borders ?? []
            let filteredCountries = countries.filter { borders.contains($0.cca3 ?? "") }
            borderStatus = .success(filteredCountries)
        } catch {
            borderStatus = .failure(.error(error.localizedDescription))
        }
    }
}

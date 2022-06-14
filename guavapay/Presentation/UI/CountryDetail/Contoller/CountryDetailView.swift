//
//  CountryDetailView.swift
//  guavapay
//
//  Created by Ali Almasli on 13.06.22.
//

import SwiftUI
import MapKit

struct CountyDetailView<Model>: View where Model: CountryDetailViewModel {
    @ObservedObject private var viewModel: Model
    
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Flag")
                    Spacer()
                    Text(viewModel.flag)
                }
                
                HStack {
                    Text("Capital")
                    Spacer()
                    Text(viewModel.capital)
                }
                
                HStack {
                    Text("Currency")
                    Spacer()
                    Text(viewModel.currency)
                }
            }
            
            Section("National languages") {
                ForEach(viewModel.languages, id: \.self) { language in
                    Text(language)
                }
            }
            
            Section("Map") {
                Map(coordinateRegion: $viewModel.region).frame(height: 300).cornerRadius(8)
            }
            
            Section("Borders") {
                if case .loading = viewModel.borderStatus {
                    ProgressView()
                } else if case .failure(let error) = viewModel.borderStatus {
                    Text(error.localizedDescription)
                } else if case .success(let countries) = viewModel.borderStatus {
                    ForEach(countries, id: \.self) { country in
                        if let repository = CountriesRepositoryImpl(apiService: .shared, cacheService: .shared),
                           let vm = CountryDetailViewModelImpl(country: country, countriesRepository: repository) as? Model {
                            NavigationLink(destination: CountyDetailView(viewModel: vm)) {
                                Text(country.name.common)
                            }
                        }
                    }
                }
            }
            
        }.navigationTitle(viewModel.title)
    }
}

//
//  ContinentsViewModel.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

protocol ContinentsViewModel {
    var continents: Continents { get }
}

class ContinentsViewModelImpl: ContinentsViewModel {
    var continents: Continents {
        return [
            Continent(title: "Africa", value: "africa"),
            Continent(title: "Americas", value: "americas"),
            Continent(title: "Asia", value: "asia"),
            Continent(title: "Europe", value: "europe"),
            Continent(title: "Oceania", value: "oceania"),
        ]
    }
}

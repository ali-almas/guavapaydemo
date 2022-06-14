//
//  Continent.swift
//  guavapay
//
//  Created by Ali Almasli on 10.06.22.
//

import Foundation

typealias Continents = [Continent]

struct Continent: Codable {
    let title: String
    let value: String
}

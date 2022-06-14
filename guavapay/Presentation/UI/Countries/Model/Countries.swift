//
//  Countries.swift
//  guavapay
//
//  Created by Ali Almasli on 11.06.22.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable, Hashable {
    let name: Name
    let currencies: [String: Aed]?
    let capital: [String]?
    let languages: [String: String]?
    let latlng: [Double]
    let borders: [String]?
    let flag: String
    let maps: Maps
    let capitalInfo: CapitalInfo
    let cioc: String?
    let cca3: String?
    
    var fullCurrency: String {
        if let key = currencies?.keys.first, let cur = currencies?[key] {
            return "\(cur.name) (\(cur.symbol ?? "NS"))"
        }
        
        return "None"
    }
    
    var nathionalLanguages: [String] {
        return languages?.map { $0.value } ?? []
    }
}

struct CapitalInfo: Codable, Hashable  {
    let latlng: [Double]?
}

struct CoatOfArms: Codable, Hashable  {
    let png: String?
    let svg: String?
}

struct Aed: Codable, Hashable  {
    let name: String
    let symbol: String?
}

struct Maps: Codable, Hashable  {
    let googleMaps, openStreetMaps: String
}

struct Name: Codable, Hashable  {
    let common, official: String
    let nativeName: [String: Translation]?
    
    var commonNativeName: String? {
        guard let key = nativeName?.keys.first else {
            return nil
        }
        
        return nativeName?[key]?.common
    }
    
    var officialNativeName: String? {
        guard let key = nativeName?.keys.first else {
            return nil
        }
        
        return nativeName?[key]?.official
    }
}

struct Translation: Codable, Hashable  {
    let official, common: String
}

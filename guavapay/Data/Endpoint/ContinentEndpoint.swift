//
//  ContinentEndpoint.swift
//  guavapay
//
//  Created by Ali Almasli on 11.06.22.
//

import Foundation

struct ContinentEndpoint: Endpoint {
    let region: String
    
    init(region: String) {
        self.region = region
    }
    
    var route: String {
        return "region/\(region)"
    }
}

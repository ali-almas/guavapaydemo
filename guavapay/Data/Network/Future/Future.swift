//
//  Future.swift
//  guavapay
//
//  Created by Ali Almasli on 14.06.22.
//

import Foundation

enum Future<T> {
    case idle
    case loading
    case failure(NetworkError)
    case success(T)
}

//
//  MoviesRequestDTO+Mapping.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}

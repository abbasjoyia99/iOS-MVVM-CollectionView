//
//  MoviesQueryListItemViewModel.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

class MoviesQueryListItemViewModel {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryListItemViewModel: Equatable {
    static func == (lhs: MoviesQueryListItemViewModel, rhs: MoviesQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}

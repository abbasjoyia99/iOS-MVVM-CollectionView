//
//  MoviesListItemViewModel.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//
// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct MoviesListItemViewModel: Equatable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterImagePath: String?
    var isFavourite: Bool?
}

extension MoviesListItemViewModel {

    init(movie: Movie) {
        self.title = movie.title ?? ""
        self.posterImagePath = movie.posterPath
        self.overview = movie.overview ?? ""
        self.isFavourite = movie.isFavourite 
        if let releaseDate = movie.releaseDate {
            self.releaseDate = "\(dateFormatter.string(from: releaseDate))"
        } else {
            self.releaseDate = NSLocalizedString("To be announced", comment: "")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

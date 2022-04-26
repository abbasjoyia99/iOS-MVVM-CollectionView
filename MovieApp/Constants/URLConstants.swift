//
//  URLConstants.swift
//  MovieApp
//
//  Created by Developer on 20/04/2022.
//

import Foundation
struct APPURL {
    
    private struct Domains {
        static let Dev = "https://api.themoviedb.org/"
        static let Poster = "https://image.tmdb.org/"
    
    }
    static var MovieList: String {
        return Domains.Dev 
    }
    static var MovieSearch: String {
        return Domains.Dev 
    }
    static var MoviePoster: String {
        return Domains.Poster
    }
}

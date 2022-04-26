//
//  MoviesResponseStorage.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(for request: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: MoviesResponseDTO, for requestDto: MoviesRequestDTO)
}

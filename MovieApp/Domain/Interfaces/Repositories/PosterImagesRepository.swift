//
//  PosterImagesRepositoryInterface.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

protocol PosterImagesRepository {
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}

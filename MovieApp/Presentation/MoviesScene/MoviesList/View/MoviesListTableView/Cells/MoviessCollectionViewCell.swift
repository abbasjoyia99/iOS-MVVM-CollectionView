//
//  MoviessCollectionViewCell.swift
//  MovieApp
//
//  Created by Developer on 20/04/2022.
//

import UIKit

protocol CollectionCellProtocol {
    func didFavouriteButtonPressed(index:Int)
}

class MoviessCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MoviessCollectionViewCell.self)
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var favouriteButton: UIButton!

     var delegate:CollectionCellProtocol?
    private var viewModel: MoviesListItemViewModel!
    private var posterImagesRepository: PosterImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    func fill(with viewModel: MoviesListItemViewModel, posterImagesRepository: PosterImagesRepository?,tag:Int) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository

        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.releaseDate
        updatePosterImage(width: Int(60))
        self.favouriteButton.tag = tag
        self.viewModel.isFavourite! ? self.favouriteButton.setImage(UIImage(named: "heartFill"), for: .normal):self.favouriteButton.setImage(UIImage(named: "heart"), for: .normal)
    }

    private func updatePosterImage(width: Int) {
        posterImageView.image = nil
        guard let posterImagePath = viewModel.posterImagePath else { return }

        imageLoadTask = posterImagesRepository?.fetchImage(with: posterImagePath, width: width) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.posterImagePath == posterImagePath else { return }
            if case let .success(data) = result {
                self.posterImageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    @IBAction func btnIsFavorite(sender:UIButton) {
        if (self.delegate != nil) {
            delegate!.didFavouriteButtonPressed(index:sender.tag)
        }
    }
}

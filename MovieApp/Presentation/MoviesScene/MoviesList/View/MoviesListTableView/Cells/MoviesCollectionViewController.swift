//
//  MoviesCollectionViewController.swift
//  MovieApp
//
//  Created by Developer on 20/04/2022.
//

import UIKit

private let reuseIdentifier = "MoviessCollectionViewCell"

final class MoviesCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,CollectionCellProtocol {
    var viewModel: MoviesListViewModel!

    var posterImagesRepository: PosterImagesRepository?
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2, height: self.view.frame.size.width/2)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                collectionView!.collectionViewLayout = layout
        
    }
    func reload() {
        collectionView.reloadData()
    }

    func updateLoading(_ loading: MoviesListViewModelLoading?) {
        
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
           // nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: 44, height: 44))
           // self.collectionView. = nextPageLoadingSpinner
        case .fullScreen, .none:
            print("noting")
           // collectionView.tableFooterView = nil
        }
    }

    // MARK: - Private

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MoviessCollectionViewCell
        cell!.fill(with: viewModel.items.value[indexPath.row],
                   posterImagesRepository: posterImagesRepository,tag: indexPath.row)

        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        cell?.delegate = self
    
        return cell!
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.item)
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.view.frame.size.width/2, height: 120)
    }
    // MARK: - Cell Delegate
    func didFavouriteButtonPressed(index:Int) {
        viewModel.didSelectIsFavouriteItem(at: index)
    }

}

//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import UIKit

final class MoviesListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var moviesListContainer: UIView!
    @IBOutlet private(set) var suggestionsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var emptyDataLabel: UILabel!
    
    private var viewModel: MoviesListViewModel!
    private var posterImagesRepository: PosterImagesRepository?

    private var moviesCollectionViewController: MoviesCollectionViewController?
    
    private var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle

    static func create(with viewModel: MoviesListViewModel,
                       posterImagesRepository: PosterImagesRepository?) -> MoviesListViewController {
        let view = MoviesListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.posterImagesRepository = posterImagesRepository
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: MoviesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesCollectionViewController.self),
                  let destinationVC = segue.destination as? MoviesCollectionViewController {
                  moviesCollectionViewController = destinationVC
            moviesCollectionViewController?.viewModel = viewModel
            moviesCollectionViewController?.posterImagesRepository = posterImagesRepository
              }
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        setupSearchController()
    }

    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }

    private func updateItems() {
        moviesCollectionViewController?.reload()
    }

    private func updateLoading(_ loading: MoviesListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        moviesListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: moviesListContainer.isHidden = false
        case .none:
            moviesListContainer.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
        moviesCollectionViewController?.updateLoading(loading)
        updateQueriesSuggestions()
    }

    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }

    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

// MARK: - Search Controller

extension MoviesListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
        }
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(MoviesListViewController.getHintsFromSearchBar),
                object: searchBar)
            self.perform(
                #selector(MoviesListViewController.getHintsFromSearchBar),
                with: searchBar,
                afterDelay: 0.5)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
    @objc func getHintsFromSearchBar(_ searchBar: UISearchBar) {
        print("Hints for searchBar: \(searchBar)")
        viewModel.didSearch(query: searchBar.text!)
    }
}

extension MoviesListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}

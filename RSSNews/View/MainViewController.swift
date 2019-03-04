//
//  ViewController.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

/// A main view protocol to link actions with presenter
protocol MainView: class {

    /// Updates the data in UITableView
    func updateNewsData()
}

/// A main class of application
class MainViewController: UIViewController, MainView {

    @IBOutlet private weak var newsTableView: UITableView!

    private var newsSearchController: UISearchController!

    private var mainViewPresenter: MainViewPresenter!

    private var selectedImage: UIImageView?

    private let transition = PopAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewPresenter = MainPresenter(view: self)

        setUpTableView()
        setUpSearchBar()
        setUpPopAnimation()

        // Geting data
        mainViewPresenter.onViewDidLoad()
    }

    /// Sets up the table view
    private func setUpTableView() {
        newsTableView.dataSource = self
    }

    /// Sets up the search bar
    private func setUpSearchBar() {
        newsSearchController = UISearchController(searchResultsController: nil)

        newsSearchController.searchResultsUpdater = self
        newsSearchController.obscuresBackgroundDuringPresentation = false
        newsSearchController.searchBar.placeholder = Constants.defaultSearchBarPlaceholderText
        navigationItem.searchController = newsSearchController
        definesPresentationContext = true
    }

    /// Sets up the pop animation
    private func setUpPopAnimation() {
        transition.dismissCompletion = {
            self.selectedImage!.isHidden = false
        }
    }
}

/// An extension for viewcontroller class to use table view
extension MainViewController: UITableViewDataSource, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewPresenter.getNewsCount(isFiltering: isDataFiltering())
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier,
                                                       for: indexPath) as? RSSTableViewCell
            else {
                fatalError("This isn't a RSSUITableViewCell object!")
        }

        let newsItem = mainViewPresenter.getNewsItemByIndex(position: indexPath.row, isFiltering: isDataFiltering())

        cell.title = newsItem.title
        cell.content = newsItem.content
        cell.date = newsItem.date

        mainViewPresenter.getNewsImage(from: newsItem.imageUrl, completionHandler: { (image) in
            cell.imageContent = image
            cell.addImageGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapImageView)))
        })

        return cell
    }

    func updateNewsData() {
        newsTableView.reloadData()
    }

    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView
        //present details view controller
        guard let imageDetails = storyboard!.instantiateViewController(withIdentifier: Constants.fullImageViewControllerIdentifier)
            as? FullImageViewController else {
                fatalError("Controller initializing error!")
        }
        imageDetails.fullImageContent = selectedImage?.image
        imageDetails.transitioningDelegate = self
        present(imageDetails, animated: true, completion: nil)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)

        transition.presenting = true
        selectedImage!.isHidden = true

        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

/// An extension fore viewcontroller class to use search bar
extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    /// Filters news items by search query text
    ///
    /// - Parameters:
    ///   - searchText: Text to searching by
    ///   - scope: Scope name (soon)
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        mainViewPresenter.updateFilteredNewsBySearchText(forSearchText: searchText)
    }

    /// Checks searchbar emptiness
    ///
    /// - Returns: True if the searchbar is empty, false otherwise
    private func searchBarIsEmpty() -> Bool {
        return newsSearchController.searchBar.text?.isEmpty ?? true
    }

    /// Checks the filtering mode
    ///
    /// - Returns: True if the filter mode is active, false otherwise
    private func isDataFiltering() -> Bool {
        return newsSearchController.isActive && !searchBarIsEmpty()
    }
}

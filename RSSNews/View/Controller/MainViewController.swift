//
//  ViewController.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit
import Reusable

/// A main view protocol to link actions with presenter
protocol MainView: class {

    /// Updates the data in UITableView
    func updateNewsData()

    /// Shows the error message in Toast
    ///
    /// - Parameter message: Message to show
    func showErrorMessage(message: String)
}

/// A main class of application
class MainViewController: UIViewController, StoryboardBased {

    @IBOutlet private weak var newsTableView: UITableView!

    private var newsSearchController: UISearchController!

    private var mainViewPresenter: MainViewPresenter!

    private var selectedImage: UIImageView?

    private let transition = PopAnimator()

    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewPresenter = MainPresenter(view: self)

        setUpTableView()
        setUpSearchBar()
        setUpPopAnimation()
        setUpRefreshControl()

        // Geting data
        mainViewPresenter.loadData()

        LoaderAnimator.showLoader(view: self.view)
    }

    /// Sets up the table view
    private func setUpTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
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

    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDidPull), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
    }

}

/// A MVP interface implementation
extension MainViewController: MainView {

    func updateNewsData() {
        LoaderAnimator.stopLoader()
        refreshControl.endRefreshing()
        newsTableView.isHidden = false
        newsTableView.reloadData()
    }

    func showErrorMessage(message: String) {
        Toast.show(view: self.view, message: message, duration: Constants.toastDuration)
    }
}

/// An extension for viewcontroller class to use table view
extension MainViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewPresenter.currentNewsCount(isFiltering: isDataFiltering())
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(for: indexPath) as RSSTableViewCell?
            else {
                fatalError("This isn't a RSSUITableViewCell object!")
        }

        let newsItem = mainViewPresenter.newsItemByIndex(position: indexPath.row, isFiltering: isDataFiltering())

        cell.title = newsItem.title
        cell.content = newsItem.content
        cell.date = newsItem.date

        mainViewPresenter.newsImageByUrl(from: newsItem.imageUrl, completionHandler: { (image) in
            cell.imageContent = image
            cell.addImageGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapImageView)))
        })

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let fullInfoDetails = FullInfoViewController.instantiate()
        fullInfoDetails.infoNewsItem = mainViewPresenter.newsItemByIndex(position: indexPath.row, isFiltering: isDataFiltering())
        self.navigationController!.pushViewController(fullInfoDetails, animated: true)
    }

    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView

        let imageDetails = FullImageViewController.instantiate()
        imageDetails.fullImageContent = selectedImage?.image
        imageDetails.transitioningDelegate = self
        imageDetails.modalPresentationStyle = .overCurrentContext
        present(imageDetails, animated: true, completion: {
            self.selectedImage!.isHidden = false
        })
    }

    @objc func refreshDidPull(_ refreshControl: UIRefreshControl) {
        mainViewPresenter.loadData()
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

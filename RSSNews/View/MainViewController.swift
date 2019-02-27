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

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewPresenter = MainPresenter(view: self)

        setUpTableView()
        setUpSearchBar()

        // Geting data
        mainViewPresenter.onViewDidLoad()
    }

    /// Sets up the table view
    func setUpTableView() {
        newsTableView.dataSource = self
    }

    /// Sets up the search bar
    func setUpSearchBar() {
        newsSearchController = UISearchController(searchResultsController: nil)

        newsSearchController.searchResultsUpdater = self
        newsSearchController.obscuresBackgroundDuringPresentation = false
        newsSearchController.searchBar.placeholder = "Search news"
        navigationItem.searchController = newsSearchController
        definesPresentationContext = true
    }

}

/// An extension for viewcontroller class to use table view
extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewPresenter.getNewsCount(isFiltering: isDataFiltering())
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RSSUITableViewCell", for: indexPath) as? RSSTableViewCell
            else {
                fatalError("This isn't a RSSUITableViewCell object!")
        }

        let newsItem = mainViewPresenter.getNewsItemByIndex(position: indexPath.row, isFiltering: isDataFiltering())

        cell.title = newsItem.title
        cell.content = newsItem.content

        mainViewPresenter.getNewsImage(from: newsItem.imageUrl, completionHandler: { (image) in
            cell.imageContent = image
        })

        return cell
    }

    func updateNewsData() {
        newsTableView.reloadData()
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
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        mainViewPresenter.updateFilteredNewsBySearchText(forSearchText: searchText)
    }

    /// Checks searchbar emptiness
    ///
    /// - Returns: True if the searchbar is empty, false otherwise
    func searchBarIsEmpty() -> Bool {
        return newsSearchController.searchBar.text?.isEmpty ?? true
    }

    /// Checks the filtering mode
    ///
    /// - Returns: True if the filter mode is active, false otherwise
    func isDataFiltering() -> Bool {
        return newsSearchController.isActive && !searchBarIsEmpty()
    }
}

//
//  ViewController.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

protocol MainView: class {
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

        // Geting data
        mainViewPresenter.onViewDidLoad()

        // Setting up controls
        setUpTableView()
        setUpSearchBar()

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

        let newsItem = mainViewPresenter.getNewsItemByIndex(index: indexPath.row, isFiltering: isDataFiltering())

        cell.title = newsItem.title
        cell.content = newsItem.content
//        cell.imageContent = normalizeImage(image: UIImage(named: "default_icon")!, scaledToSize: CGSize(width: 64, height: 64))
        cell.imageContent = UIImage(named: "default_icon")
        return cell
    }

    func normalizeImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {

        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.automatic)
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

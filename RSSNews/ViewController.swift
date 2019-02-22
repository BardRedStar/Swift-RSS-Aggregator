//
//  ViewController.swift
//  RSSNews
//
//  Created by User on 09/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import UIKit

/// A main class of application
class ViewController: UIViewController {
    
    @IBOutlet private weak var newsTableView: UITableView!
    
    private var newsSearchController: UISearchController!
    
    private var newsArray: [NewsItem]!
    private var filteredNewsArray: [NewsItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Geting data
        readPropertyList()
        
        // Setting up controls
        setUpTableView()
        setUpSearchBar()
    }
    
    /// Reads the news from the properties file (.pfile) and put it into global dictionary
    func readPropertyList(){
        
        if let path = Bundle.main.path(forResource: "news", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path){
            
            newsArray = try? PropertyListDecoder().decode([NewsItem].self, from: xml)
            filteredNewsArray = [NewsItem]()
        } else {
            fatalError("File is not found!")
        }
    }
    
    /// Sets up the table view
    func setUpTableView(){
        newsTableView.dataSource = self
    }
    
    /// Sets up the search bar
    func setUpSearchBar(){
        newsSearchController = UISearchController(searchResultsController: nil)
        
        newsSearchController.searchResultsUpdater = self
        newsSearchController.obscuresBackgroundDuringPresentation = false
        newsSearchController.searchBar.placeholder = "Search news"
        navigationItem.searchController = newsSearchController
        definesPresentationContext = true
    }
}

/// An extension for viewcontroller class to use table view
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isDataFiltering()) ? filteredNewsArray.count : newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RSSUITableViewCell", for: indexPath) as? RSSTableViewCell
            else {
                fatalError("This isn't a RSSUITableViewCell object!")
        }
        
        let newsItem = (isDataFiltering()) ? filteredNewsArray[indexPath.row] : newsArray[indexPath.row]
        
        cell.title = newsItem.title
        cell.content = newsItem.content
        
        return cell
    }
}

/// An extension fore viewcontroller class to use search bar
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    /// Filters news items by search query text
    ///
    /// - Parameters:
    ///   - searchText: Text to searching by
    ///   - scope: Scope name (soon)
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNewsArray.removeAll()
        filteredNewsArray = newsArray!.filter({(item: NewsItem) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased()) ||
                item.content.lowercased().contains(searchText.lowercased())
        })
        
        newsTableView.reloadData()
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

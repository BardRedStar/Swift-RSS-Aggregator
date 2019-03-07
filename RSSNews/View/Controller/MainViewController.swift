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

    private var expandState: [Bool]!

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

    /// Shows message in Toast
    ///
    /// - Parameters:
    ///   - message: Message string to show
    ///   - duration: Toast lifetime
    func showToast(message: String, duration: Double) {

        let toastTextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 1.2, height: 0))

        toastTextView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastTextView.textColor = UIColor.white
        toastTextView.textAlignment = .center
        toastTextView.text = message
        toastTextView.frame.size.height = toastTextView.intrinsicContentSize.height
        toastTextView.sizeToFit()

        /// Put it to start position
        toastTextView.frame.origin.x = self.view.frame.size.width / 2 - toastTextView.frame.size.width / 2
        toastTextView.frame.origin.y = self.view.frame.size.height

        /// Set opacity and corner bounds
        toastTextView.alpha = 0.0
        toastTextView.layer.cornerRadius = toastTextView.frame.size.height / 4
        toastTextView.clipsToBounds = true

        self.view.addSubview(toastTextView)
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseInOut, animations: {

            toastTextView.alpha += 1.0
            toastTextView.frame.origin.y -= self.view.frame.size.height / 15 + toastTextView.frame.size.height

        }, completion: { isCompleted in

            UIView.animate(withDuration: 0.7, delay: duration, options: .curveEaseInOut, animations: {

                toastTextView.alpha -= 1.0
                toastTextView.frame.origin.y += self.view.frame.size.height / 10 + toastTextView.frame.size.height

            }, completion: { isCompleted in
                toastTextView.removeFromSuperview()
            })
        })

    }
}

/// A MVP interface implementation
extension MainViewController: MainView {

    func updateNewsData() {
        expandState = Array(repeating: false, count: mainViewPresenter.currentNewsCount(isFiltering: isDataFiltering()))
        newsTableView.reloadData()
    }

    func showErrorMessage(message: String) {
        showToast(message: message, duration: 2.0)
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

        cell.isExpanded = expandState[indexPath.row]

        mainViewPresenter.newsImageByUrl(from: newsItem.imageUrl, completionHandler: { (image) in
            cell.imageContent = image
            cell.addImageGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapImageView)))
        })

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandState[indexPath.row] = !expandState[indexPath.row]
    }

    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView

        let imageDetails = FullImageViewController.instantiate()
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
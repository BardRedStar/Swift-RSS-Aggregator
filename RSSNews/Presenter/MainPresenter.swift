//
//  MainPresenter.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A protocol to link presenter to main view
protocol MainViewPresenter {

    /// - Parameter view: View to bind presenter to
    init(view: MainView)

    /// Does actions after view has been initialized
    func onViewDidLoad()

    /// Gets current news count depend on filtering state
    ///
    /// - Parameter isFiltering: Filtering state (true if the search bar is not empty, false otherwise)
    /// - Returns: Amount of news by typed filtering state
    func getNewsCount(isFiltering: Bool) -> Int

    /// Gets news item by it's index in array
    ///
    /// - Parameters:
    ///   - position: Index in current news array
    ///   - isFiltering: Filtering state (true if the search bar is not empty, false otherwise)
    /// - Returns: News item object by it's position (index)
    func getNewsItemByIndex(position: Int, isFiltering: Bool) -> NewsItem

    /// Filters news by search text including titles and content
    ///
    /// - Parameter searchText: Text for searching in news
    func updateFilteredNewsBySearchText(forSearchText searchText: String)

    /// Gets image of news post by it's URL asyncronously
    ///
    /// - Parameters:
    ///   - imageUrl: URL adress of image
    ///   - completionHandler: Handler to get image when it will be completely loaded
    func getNewsImage(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void)
}

/// A class for absorb business logic (according to MVP)
class MainPresenter: MainViewPresenter {

    unowned let view: MainView

    private var newsArray: [NewsItem] = []
    private var filteredNewsArray: [NewsItem] = []

    required init(view: MainView) {
        self.view = view
    }

    /// Overriden protocol methods

    func onViewDidLoad() {
        loadNewsFromRemote()
    }

    func getNewsCount(isFiltering: Bool) -> Int {
        return isFiltering ? filteredNewsArray.count : newsArray.count
    }

    func getNewsItemByIndex(position: Int, isFiltering: Bool) -> NewsItem {
        return isFiltering ? filteredNewsArray[position] : newsArray[position]
    }

    func updateFilteredNewsBySearchText(forSearchText searchText: String) {
        filteredNewsArray.removeAll()
        filteredNewsArray = newsArray.filter({(item: NewsItem) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased()) || item.content.lowercased().contains(searchText.lowercased())
        })
        view.updateNewsData()
    }

    func getNewsImage(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void) {
        
        let name = Cryptography.MD5(from: imageUrl)
        let cacheApiInstance = CacheAPI.instance

        if cacheApiInstance.isImageExists(imageFileName: name) {
            cacheApiInstance.getImageFromCache(imageFileName: name, completionHandler: { data in
                handler(data != nil ? UIImage(data: data!)! : UIImage(named: "default_icon")!)
            })
        } else {
            RemoteAPI.instance.getImageByUrl(url: imageUrl, completionHandler: { data in
                cacheApiInstance.saveImageInCache(imageName: imageUrl, content: data)
                handler(UIImage(data: data)!)
            })
        }
    }

    /// Private presenter methods

    /// Tries to load news from remote API
    private func loadNewsFromRemote() {
        RemoteAPI.instance.loadNewsFromSource(completionHandler: { newsEntity in

            /// Clear old data
            self.newsArray.removeAll()
            self.filteredNewsArray.removeAll()

            if newsEntity != nil {
                self.newsArray = NewsMapper.mapEntityToItemArray(entity: newsEntity!)
            }

            self.view.updateNewsData()
        })
    }
}

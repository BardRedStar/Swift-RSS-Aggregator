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
    func currentNewsCount(isFiltering: Bool) -> Int

    /// Gets news item by it's index in array
    ///
    /// - Parameters:
    ///   - position: Index in current news array
    ///   - isFiltering: Filtering state (true if the search bar is not empty, false otherwise)
    /// - Returns: News item object by it's position (index)
    func newsItemByIndex(position: Int, isFiltering: Bool) -> NewsItem

    /// Filters news by search text including titles and content
    ///
    /// - Parameter searchText: Text for searching in news
    func updateFilteredNewsBySearchText(forSearchText searchText: String)

    /// Gets image of news post by it's URL asyncronously
    ///
    /// - Parameters:
    ///   - imageUrl: URL adress of image
    ///   - completionHandler: Handler to get image when it will be completely loaded
    func newsImageByUrl(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void)
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

    func currentNewsCount(isFiltering: Bool) -> Int {
        return isFiltering ? filteredNewsArray.count : newsArray.count
    }

    func newsItemByIndex(position: Int, isFiltering: Bool) -> NewsItem {
        return isFiltering ? filteredNewsArray[position] : newsArray[position]
    }

    func updateFilteredNewsBySearchText(forSearchText searchText: String) {

        filteredNewsArray = newsArray.filter({(item: NewsItem) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased()) || item.content.lowercased().contains(searchText.lowercased())
        })
        view.updateNewsData()
    }

    func newsImageByUrl(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void) {

        let name = Cryptography.MD5(from: imageUrl)
        let cacheApiInstance = CacheRepository.instance

        if cacheApiInstance.isImageExists(imageFileName: name) {
            cacheApiInstance.imageFromCache(imageFileName: name, completionHandler: { data in
                handler(data != nil ? UIImage(data: data!)! : UIImage(named: Constants.resourcesDefaultIconName)!)
            })
        } else {
            NetworkRepository.instance.imageByUrl(url: imageUrl, completionHandler: { result in
                switch result {
                case .success(let value):
                    cacheApiInstance.saveImageInCache(imageName: imageUrl, content: value)
                    handler(UIImage(data: value)!)
                case .failure(let error):
                    self.view.showErrorMessage(message: error.localizedDescription)
                }
            })
        }
    }

    /// Private presenter methods

    /// Tries to load news from remote API
    private func loadNewsFromRemote() {
        NetworkRepository.instance.loadNewsFromSource(completionHandler: { result in

            switch result {
            case .success(let value):
                let newsEntity: NewsEntity? = try? JSONDecoder().decode(NewsEntity.self, from: value)

                if newsEntity != nil {
                    self.newsArray = NewsMapper.mapEntityToItemArray(entity: newsEntity!)
                } else {
                    self.view.showErrorMessage(message: "Getting news error! Source is unavailable!")
                }
            case .failure(let error):
                self.view.showErrorMessage(message: error.localizedDescription)
            }

            self.view.updateNewsData()
        })
    }

}

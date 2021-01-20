//
//  MainPresenter.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Combine
import Foundation
import UIKit

/// A protocol to link presenter to main view
protocol MainViewPresenter {
    /// - Parameter view: View to bind presenter to
    init(view: MainView)

    /// Does actions after view has been initialized
    func loadData()

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
    func newsItemByPosition(position: Int, isFiltering: Bool) -> NewsItem

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

    /// Gets name of the current news source
    ///
    /// - Returns: Source name string
    func newsSourceName() -> String
}

/// A class for absorb business logic (according to MVP)
class MainPresenter: MainViewPresenter {
    unowned let view: MainView

    private var newsArray: [NewsItem] = []
    private var filteredNewsArray: [NewsItem] = []

    private var disposeBag = Set<AnyCancellable>()

    private var newsSourcesArray: [SourceItem]!

    required init(view: MainView) {
        self.view = view

        loadSourcesList()
    }

    /// Overriden protocol methods

    func loadData() {
        loadNewsFromRemote()
    }

    func currentNewsCount(isFiltering: Bool) -> Int {
        return isFiltering ? filteredNewsArray.count : newsArray.count
    }

    func newsItemByPosition(position: Int, isFiltering: Bool) -> NewsItem {
        return isFiltering ? filteredNewsArray[position] : newsArray[position]
    }

    func updateFilteredNewsBySearchText(forSearchText searchText: String) {
        filteredNewsArray = newsArray.filter { (item: NewsItem) -> Bool in
            item.title.lowercased().contains(searchText.lowercased()) || item.content.lowercased().contains(searchText.lowercased())
        }
        view.updateNewsData()
    }

    func newsImageByUrl(from imageUrl: String) -> AnyPublisher<UIImage, Never> {
        let name = Cryptography.MD5(from: imageUrl)
        let cacheApiInstance = CacheRepository.instance

        if cacheApiInstance.isImageExists(imageFileName: name) {
            cacheApiInstance.imageFromCache(imageFileName: name, completionHandler: { data in
                handler(data != nil ? UIImage(data: data!)! : UIImage(named: Constants.resourcesDefaultIconName)!)
            })
        } else {
            return getFromInternet()
                .handleEvents(receiveSubscription: nil, receiveOutput: { data in
                    cacheApiInstance.saveImageInCache(imageName: imageUrl, content: data)
                })
                .catch { error -> Empty<UIImage, Never> in
                    self.view.showErrorMessage(message: error.localizedDescription)
                    return Empty<UIImage, Never>()
                }.eraseToAnyPublisher()
        }
    }

    func getFromInternet() -> AnyPublisher<UIImage, Error> {
        return NetworkRepository.instance.imageByUrl(url: imageUrl)
            .tryMap { response throws -> Data in
                if let error = response.error {
                    throw error
                }
                return response.data!
            }

            .map { data in
                UIImage(data: data)!
            }.eraseToAnyPublisher()
    }

    func newsSourceName() throws -> String {
        let currentSourceName = UserDefaultsRepository.instance.stringProperty(forKey:
            SettingsSection.SourceSection.source.rawValue.lowercased())

        let sourceItem = newsSourcesArray.first {
            $0.sourceName == currentSourceName
        }
        return sourceItem != nil ? (sourceItem!.sourceName ?? "Home") : "Home"
    }

    /// Tries to load news from remote API
    private func loadNewsFromRemote() {
        let sourceId = newsSourceId()

        print(sourceId)
        NetworkRepository.instance.loadNewsFromSource(source: sourceId)
//        , completionHandler: { result in
//
//            switch result {
//            case .success(let value):
//                do {
//                    let newsEntity: NewsEntity = try JSONDecoder().decode(NewsEntity.self, from: value)
//
//                    self.newsArray = NewsMapper.mapEntityToItemArray(entity: newsEntity)
//                } catch {
//                    self.view.showErrorMessage(message: "Getting news error! Source is unavailable!")
//                }
//
//            case .failure(let error):
//                self.view.showErrorMessage(message: error.localizedDescription)
//            }
//
//            self.view.updateNewsData()
//        })
    }

    /// Loads the sources list from property file
    private func loadSourcesList() {
        newsSourcesArray = PropertyFileRepository.instance.sourcesFromPropertyList()
    }

    /// Gets the identifier of current news source
    ///
    /// - Returns: Source identifier string
    private func newsSourceId() -> String {
        let currentSourceName = UserDefaultsRepository.instance.stringProperty(forKey:
            SettingsSection.SourceSection.source.rawValue.lowercased())

        let sourceItem = newsSourcesArray.first {
            $0.sourceName == currentSourceName
        }

        return sourceItem != nil ? (sourceItem!.sourceId ?? "none") : "none"
    }
}

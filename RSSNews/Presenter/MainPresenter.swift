//
//  MainPresenter.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import Alamofire
import CommonCrypto

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
    func getNewsImage(from imageUrl: String, completionHandler: @escaping (UIImage) -> Void)
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
        loadNews()
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

        if isImageExists(imageFileName: name) {
            getImageFromCache(imageFileName: name, completionHandler: handler)
        } else {
            getImageByUrl(url: imageUrl, completionHandler: handler)
        }
    }

    /// Private presenter methods

    /// Creates a HTTP request to API to get last news
    private func loadNews() {

        /// Hardcoded params
        let params: [String: Any] = [
            "sources": "techcrunch"
        ]

        /// Hardcoded headers
        let headers: [String: String] = [
            "Authorization": "Basic 5592af9332c14f9080c0d9132bf1efee"
        ]

        /// Request
        Alamofire.request("https://newsapi.org/v2/top-headlines", parameters: params, headers: headers)
            .validate()
            .responseString { responseString -> Void in
                switch responseString.result {
                case .success(let value):

                    let newsResponse: NewsEntity? = try? JSONDecoder().decode(NewsEntity.self, from: Data(value.utf8))

                    self.newsArray.removeAll()
                    self.filteredNewsArray.removeAll()

                    if newsResponse != nil {
                        self.newsArray = self.mapResponseToItemArray(response: newsResponse!)
                    }

                    self.view.updateNewsData()

                case .failure(let error):
                    print(error)
                }
            }
    }

    /// Parses response to NewsItem array
    ///
    /// - Parameter response: Response object
    /// - Returns: NewsItem objects array
    private func mapResponseToItemArray(response: NewsEntity) -> [NewsItem] {

        var result: [NewsItem] = []

        for article in response.articles {
            result.append(NewsItem(title: article.title!, content: article.description!, imageUrl: article.urlToImage!))
        }

        return result
    }

    /// Saves image in the cache folder with hashed name (using MD5)
    ///
    /// - Parameters:
    ///   - iamgeName: imageName
    ///   - content: image content (data)
    private func saveImageInCache(imageName: String, content: Data) {

        /// Get URL of Caches/images folder
        let fileManager = FileManager.default
        var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheURL.appendPathComponent("images", isDirectory: true)

        do {

            /// Check directory existence
            if !fileManager.fileExists(atPath: cacheURL.path) {
                try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: false, attributes: nil)
            }

            /// Save file
            cacheURL.appendPathComponent(Cryptography.MD5(from: imageName) + ".jpg")
            fileManager.createFile(atPath: cacheURL.path, contents: content, attributes: nil)

        } catch {
            print(error.localizedDescription)
        }
    }

    /// Checks image existence in the cache folder
    ///
    /// - Parameter imageName: Image name
    /// - Returns: true if image exists and false otherwise
    private func isImageExists(imageFileName imageName: String) -> Bool {
        let imageUrl = FileManagerHelper.getCachedImageUrlByName(fileName: imageName, fileExtension: ".jpg")
        return FileManager.default.fileExists(atPath: imageUrl.path)
    }

    /// Gets image from the cache folder
    ///
    /// - Parameter imageName: Image name string
    /// - Returns: Image object
    private func getImageFromCache(imageFileName imageName: String, completionHandler handler: @escaping (UIImage) -> Void) {

        /// Asyncronously get the image from cache
        DispatchQueue.global(qos: .utility).async {
            let imageUrl = FileManagerHelper.getCachedImageUrlByName(fileName: imageName, fileExtension: ".jpg")

            let imageContent = UIImage(contentsOfFile: imageUrl.path)!

            /// Return the image content to the UI on main thread
            DispatchQueue.main.async {
                handler(imageContent)
            }

        }

    }

    /// Gets image by URL and saves it in cache folder
    ///
    /// - Parameters:
    ///   - imageUrl: URL to get image by
    ///   - completionHandler: Handler to get result asycronously
    private func getImageByUrl(url imageUrl: String, completionHandler: @escaping (UIImage) -> Void) {
        Alamofire.request(imageUrl)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let data):

                    self.saveImageInCache(imageName: imageUrl, content: data)
                    completionHandler(UIImage(data: data)!)

                case .failure(let error):
                    print(error)
                }
            }

    }

}

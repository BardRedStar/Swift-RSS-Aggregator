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

protocol MainViewPresenter {

    init(view: MainView)

    func onViewDidLoad()

    func getNewsCount(isFiltering: Bool) -> Int

    func getNewsItemByIndex(index: Int, isFiltering: Bool) -> NewsItem

    func updateFilteredNewsBySearchText(forSearchText searchText: String)

    func getNewsImage(from imageUrl: String, completionHandler: @escaping (UIImage) -> Void)
}

class MainPresenter: MainViewPresenter {

    unowned let view: MainView

    private var newsArray: [NewsItem]!
    private var filteredNewsArray: [NewsItem]!

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

    func getNewsItemByIndex(index: Int, isFiltering: Bool) -> NewsItem {
        return isFiltering ? filteredNewsArray[index] : newsArray[index]
    }

    func updateFilteredNewsBySearchText(forSearchText searchText: String) {
        filteredNewsArray.removeAll()
        filteredNewsArray = newsArray!.filter({(item: NewsItem) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased()) || item.content.lowercased().contains(searchText.lowercased())
        })
        view.updateNewsData()
    }

    func getNewsImage(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void) {
        let name = Cryptography.MD5(from: imageUrl)

        if isImageExists(imageFileName: name) {
            handler(getImageFromCache(imageFileName: name))
        } else {
            getImageFromUrl(url: imageUrl, completionHandler: handler)
        }
    }

    /// Private presenter methods

    private func loadNews() {

        let params: [String: Any] = [
            "sources": "techcrunch"
        ]

        let headers: [String: String] = [
            "Authorization": "Basic 5592af9332c14f9080c0d9132bf1efee"
        ]

        Alamofire.request("https://newsapi.org/v2/top-headlines", parameters: params, headers: headers)
            .validate()
            .responseString { responseString -> Void in
                switch responseString.result {
                case .success(let value):
                    let newsResponse: NewsEntity? = try? JSONDecoder().decode(NewsEntity.self, from: Data(value.utf8))

                    self.newsArray = self.mapResponseToItemArray(response: newsResponse!)
                    self.filteredNewsArray = [NewsItem]()
                    self.view.setUpDataSource()

                case .failure(let error):
                    print(error)
                }
            }
    }

    private func mapResponseToItemArray(response: NewsEntity) -> [NewsItem] {

        var result: [NewsItem] = []

        for article in response.articles {
            result.append(NewsItem(title: article.title, content: article.description, imageUrl: article.urlToImage))
        }

        return result
    }

    private func saveImageInCache(path: String, content: Data) {
        let fileManager = FileManager.default
        var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheURL.appendPathComponent("images", isDirectory: true)

        do {

            if !fileManager.fileExists(atPath: cacheURL.path) {
                try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: false, attributes: nil)
            }

            cacheURL.appendPathComponent(Cryptography.MD5(from: path) + ".jpg")

            fileManager.createFile(atPath: cacheURL.path, contents: content, attributes: nil)

        } catch {
            print(error.localizedDescription)
        }
    }

    private func isImageExists(imageFileName imageName: String) -> Bool {
        let imageUrl = FileManagerHelper.getCachedImageUrlByName(fileName: imageName, fileExtension: ".jpg")
        print(imageUrl.path)
        return FileManager.default.fileExists(atPath: imageUrl.path)
    }

    private func getImageFromCache(imageFileName imageName: String) -> UIImage {
        let imageUrl = FileManagerHelper.getCachedImageUrlByName(fileName: imageName, fileExtension: ".jpg")
        print("From cache!")
        return UIImage(contentsOfFile: imageUrl.path)!
    }

    private func getImageFromUrl(url imageUrl: String, completionHandler: @escaping (UIImage) -> Void) {
        Alamofire.request(imageUrl)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let data):

                    self.saveImageInCache(path: imageUrl, content: data)
                    print("From API!")
                    completionHandler(UIImage(data: data)!)

                case .failure(let error):
                    print(error)
                }
            }

    }

}

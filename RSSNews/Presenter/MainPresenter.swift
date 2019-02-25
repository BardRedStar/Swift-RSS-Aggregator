//
//  MainPresenter.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

protocol MainViewPresenter {

    init(view: MainView)

    func onViewDidLoad()

    func getNewsCount(isFiltering: Bool) -> Int

    func getNewsItemByIndex(index: Int, isFiltering: Bool) -> NewsItem

    func updateFilteredNewsBySearchText(forSearchText searchText: String)
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
        readPropertyList()
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

    /// Private presenter methods

    /// Reads the news from the properties file (.pfile) and put it into global dictionary
    private func readPropertyList() {

        if let path = Bundle.main.path(forResource: "news", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {

            newsArray = try? PropertyListDecoder().decode([NewsItem].self, from: xml)
            filteredNewsArray = [NewsItem]()
        } else {
            fatalError("File is not found!")
        }
    }

}

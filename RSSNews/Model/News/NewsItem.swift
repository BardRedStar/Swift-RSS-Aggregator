//
//  NewsItem.swift
//  RSSNews
//
//  Created by User on 21/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A data-class for holding the news item information
struct NewsItem: Codable {
    var title: String
    var content: String
    var imageUrl: String
    var date: String

    /// - Parameters:
    ///   - title: News item title
    ///   - content: News item content
    init(title: String, content: String, imageUrl: String, date: String) {
        self.title = title
        self.content = content
        self.imageUrl = imageUrl
        self.date = date
    }
}
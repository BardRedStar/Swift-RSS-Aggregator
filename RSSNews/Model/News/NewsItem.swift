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
    var sourceUrl: String
    var sourceName: String
    var author: String

    /// - Parameters:
    ///   - title: News item title
    ///   - content: News item content
    ///   - imageUrl: URL to image
    ///   - date: publish date
    ///   - sourceUrl: url to source article
    init(title: String, content: String, imageUrl: String, date: String, sourceUrl: String, sourceName: String, author: String) {
        self.title = title
        self.content = content
        self.imageUrl = imageUrl
        self.date = date
        self.sourceUrl = sourceUrl
        self.sourceName = sourceName
        self.author = author
    }
}

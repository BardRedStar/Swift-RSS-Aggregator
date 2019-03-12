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
}

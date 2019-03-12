//
//  NewsResponse.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A data-structure for parsing JSON response from news API
struct NewsEntity: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

/// A data-structure for parsing JSON response from news API
struct Article: Codable {
    let source: Source
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

/// A data-structure for parsing JSON response from news API
struct Source: Codable {
    let id: String?
    let name: String?
}

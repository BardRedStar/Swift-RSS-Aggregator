//
//  NewsResponse.swift
//  RSSNews
//
//  Created by User on 25/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

public struct NewsEntity: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

public struct Article: Codable {
    let source: Source
    let author, title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

public struct Source: Codable {
    let id: String
    let name: String
}

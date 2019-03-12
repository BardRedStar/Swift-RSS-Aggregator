//
//  Mappers.swift
//  RSSNews
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A class for mapping (convert) news entity objects to data objects and vice versa
final class NewsMapper {

    /// Parses NewsEntity to NewsItem array
    ///
    /// - Parameter entity: Entity object
    /// - Returns: NewsItem objects array
    class func mapEntityToItemArray(entity: NewsEntity) -> [NewsItem] {
        return entity.articles.compactMap({ article -> NewsItem? in
            if let publushedAt = article.publishedAt, let sourceUrl = article.url {
                let date = DateTimeManager.elapsedTime(from: DateTimeManager.convertUTCStringToDateFormat(from: publushedAt))
                return NewsItem(title: article.title ?? "No title",
                                content: article.description ?? "No description",
                                imageUrl: article.urlToImage!,
                                date: date,
                                sourceUrl: sourceUrl,
                                sourceName: article.source.name ?? "Unknown",
                                author: article.author ?? "Unknown")

            } else {
                return nil
            }
        })
    }

}

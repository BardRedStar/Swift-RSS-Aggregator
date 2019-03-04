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

        var result: [NewsItem] = []

        for article in entity.articles {
            result.append(NewsItem(title: article.title!, content: article.description!, imageUrl: article.urlToImage!))
        }

        return result
    }

}

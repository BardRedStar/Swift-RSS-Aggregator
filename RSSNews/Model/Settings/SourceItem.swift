//
//  SourceItem.swift
//  RSSNews
//
//  Created by User on 13/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

struct SourceItem: Codable, Equatable {
    var sourceName: String?
    var sourceId: String?

    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case sourceId = "source_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.sourceName = try? container.decode(String.self, forKey: .sourceName)
        self.sourceId = try? container.decode(String.self, forKey: .sourceId)
    }

    static func == (lhs: SourceItem, rhs: SourceItem) -> Bool {
        return lhs.sourceName == rhs.sourceName && lhs.sourceId == lhs.sourceId
    }
}

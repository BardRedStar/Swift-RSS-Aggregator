//
//  PropertyFileHelper.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A class for working with property lists (.plist)
class PropertyFileRepository {

    /// Singleton
    static let instance = PropertyFileRepository()

    private init() {
    }

    /// Gets sources list from sources property file
    ///
    /// - Returns: List of sources from file or nil if parsing error occured
    func sourcesFromPropertyList() -> [SourceItem]? {
        if let path = Bundle.main.path(forResource: "sources", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) {

            do {
                let sourceArray = try PropertyListDecoder().decode([SourceItem].self, from: xml)
                return sourceArray
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

}

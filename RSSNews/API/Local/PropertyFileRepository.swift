//
//  PropertyFileHelper.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

class PropertyFileRepository {

    /// Singleton
    static let instance = PropertyFileRepository()

    private init() {
    }

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

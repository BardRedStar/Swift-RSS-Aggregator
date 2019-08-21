//
//  UserDefaultsRepository.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A class to work with iOS UserDefault tool
class UserDefaultsRepository {

    /// Singleton
    static let instance = UserDefaultsRepository()

    private init() {
    }

    /// Gets string property by key
    ///
    /// - Parameter key: Key to get property
    /// - Returns: String property by key or nil if error occured
    func stringProperty(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    /// Gets string properties list by keys list
    ///
    /// - Parameter key: Keys list
    /// - Returns: String properties list by keys list
    func stringProperty(forKey key: [String]) -> [String] {
        return key.compactMap({ (key) in
            return stringProperty(forKey: key)
        })
    }

    /// Saves string property in UserDefaults by key
    ///
    /// - Parameters:
    ///   - key: Key to save by
    ///   - value: Value to save
    func saveStringProperty(forKey key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    /// Saves string properties dictionary in UserDefaults by keys
    ///
    /// - Parameter dictionary: Properties dictionary to save
    func saveStringPropertiesDictionary(dictionary: [String: String]) {
        for (key, value) in dictionary {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
}

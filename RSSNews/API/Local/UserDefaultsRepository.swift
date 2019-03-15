//
//  UserDefaultsRepository.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

class UserDefaultsRepository {

    /// Singleton
    static let instance = UserDefaultsRepository()

    private init() {
    }

    func stringProperty(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    func stringProperty(forKey key: [String]) -> [String] {
        return key.compactMap({ (key) in
            return stringProperty(forKey: key)
        })
    }

    func saveStringProperty(forKey key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func saveStringPropertiesDictionary(dictionary: [String: String]) {
        for (key, value) in dictionary {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
}

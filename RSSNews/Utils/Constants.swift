//
//  Constants.swift
//  RSSNews
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A struct for holding useful constants
struct Constants {

    /// Constant enumerator for animation values
    ///
    /// - popDiration: Duration of pop animation
    /// - popDelay: Delay before pop animation starts
    enum Animation: Double {
        case popDuration = 0.25
        case popDelay = 0.0
    }

    /// Constant enumerator for image params
    ///
    /// - cacheFolderName: Name of folder in Library/Caches/
    /// - fileExtension: Extension of image files in cache
    enum Image: String {
        case cacheFolderName = "images"
        case fileExtension = ".jpg"
    }

    /// Constant enumerator for resources
    ///
    /// - defaultIconName: Default icon resource name
    enum Resources: String {
        case defaultIconName = "default_icon"
    }

    /// Constant enumerator for API params
    ///
    /// - key: API key from https://newsapi.org/
    /// - url: Rss URL to get news by
    enum API: String {
        case key = "5592af9332c14f9080c0d9132bf1efee"
        case url = "https://newsapi.org/v2/top-headlines"
    }

    /// Constant enumerator for identifiers
    ///
    /// - tableViewCell: TableViewCell identifier
    /// - fullImageViewController: FullImageViewController identifier
    enum Identifiers: String {
        case tableViewCell = "RSSUITableViewCell"
        case fullImageViewController = "FullImageViewController"
    }

    /// Constant enumerator for output params
    ///
    /// - separator: Separator between print phrases
    enum Output: String {
        case separator = " "
    }

    /// Constant enumerator for default values of UI controls
    ///
    /// - searchBarPlaceholder: Default placeholder text in SearchBar
    enum DefaultViewValues: String {
        case searchBarPlaceholder = "Search news"
    }
}

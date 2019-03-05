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

    /// Animation

    /// Duration of pop animation
    static let popAnimationDuration = 0.25

    /// Delay before pop animation starts
    static let popAnimationDelay = 0.0

    /// Images and cache

    /// Name of folder in Library/Caches/
    static let imageCacheFolderName = "images"

    /// Extension of image files in cache
    static let imageFileExtension = "jpg"

    /// Duration (in days) of image files holding in cache
    static let imageCacheFileLifeDurationDays = 31

    /// Resources

    /// Default icon resource name
    static let resourcesDefaultIconName = "default_icon"

    /// API

    /// API key from https://newsapi.org/
    static let apiKey = "5592af9332c14f9080c0d9132bf1efee"

    /// Rss URL to get news by
    static let apiUrl = "https://newsapi.org/v2/top-headlines"

    /// Identifiers

    /// TableViewCell identifier
    static let tableViewCellIdentifier = "RSSUITableViewCell"

    /// FullImageViewController identifier
    static let fullImageViewControllerIdentifier = "FullImageViewController"

    /// Output parameters

    /// Separator between print phrases
    static let outputSeparator = " "

    /// Default view controls values

    /// Default placeholder text in SearchBar
    static let defaultSearchBarPlaceholderText = "Search news"

}

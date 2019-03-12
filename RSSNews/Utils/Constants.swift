//
//  Constants.swift
//  RSSNews
//
//  Created by User on 01/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A struct for holding useful constants
struct Constants {

    /// Animation

    /// Duration of pop animation
    static let popAnimationDuration = 0.25

    /// Delay before pop animation starts
    static let popAnimationDelay = 0.0

    /// Maximum swipe velocity for removing full image
    static let swipeImageMaximumVelocity: CGFloat = 2000.0

    /// The part (in fractions) in which image will be closed if it's center reaches this zone
    static let swipeImageCriticalPaddingZonePart = 0.2

    /// Duration in seconds for bringing image back
    static let swipeImageBackDuration = 0.5

    /// Toast duration
    static let toastDuration = 2.0

    /// Duration of the loader transform animation
    static let loaderTransformDuration = 0.5

    /// Loader shape size
    static let loaderSize: CGFloat = 20.0

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

    /// Output parameters

    /// Separator between print phrases
    static let outputSeparator = " "

    /// Default view controls values

    /// Default placeholder text in SearchBar
    static let defaultSearchBarPlaceholderText = "Search news"

}

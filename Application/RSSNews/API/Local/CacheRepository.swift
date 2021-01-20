//
//  CacheAPI.swift
//  RSSNews
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A class for operations with cache
class CacheRepository {
    /// Singleton
    static let instance = CacheRepository()

    private init() {}

    /// Saves image in the cache folder with hashed name (using MD5)
    ///
    /// - Parameters:
    ///   - imageName: imageName
    ///   - content: image content (data)
    func saveImageInCache(imageName: String, content: Data) {
        DispatchQueue.global(qos: .utility).async {
            /// Get URL of Caches/images folder
            let fileManager = FileManager.default
            var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            cacheURL.appendPathComponent(Constants.imageCacheFolderName, isDirectory: true)

            do {
                /// Check directory existence
                if !fileManager.fileExists(atPath: cacheURL.path) {
                    try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: false, attributes: nil)
                }

                /// Save file
                cacheURL.appendPathComponent(imageName + "." + Constants.imageFileExtension)
                fileManager.createFile(atPath: cacheURL.path, contents: content, attributes: nil)

            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /// Checks image existence in the cache folder
    ///
    /// - Parameter imageName: Image name
    /// - Returns: true if image exists and false otherwise
    func isImageExists(imageFileName imageName: String) -> Bool {
        let imageUrl = FileManagerHelper.cachedImageUrlByName(fileName: imageName, fileExtension: Constants.imageFileExtension)
        return FileManager.default.fileExists(atPath: imageUrl.path)
    }

    /// Gets image from the cache folder
    ///
    /// - Parameters:
    ///   - imageName: Image name
    ///   - handler: Handler for getting result asynchronously
    func imageFromCache(imageFileName imageName: String, completionHandler handler: @escaping (Data?) -> Void) {
        /// Asyncronously get the image from cache
        DispatchQueue.global(qos: .utility).async {
            let imageUrl = FileManagerHelper.cachedImageUrlByName(
                fileName: imageName,
                fileExtension: Constants.imageFileExtension
            )

            let imageContent = try? Data(contentsOf: imageUrl)

            /// Return the image content to the UI on main thread
            DispatchQueue.main.async {
                handler(imageContent)
            }
        }
    }

    /// Asynchronously checks image files in cache and removes files which elapsed time greater than constant value (see Constants.swift)
    func removeOutdatedImagesFromCache() {
        DispatchQueue.global(qos: .utility).async {
            /// Get URL of Caches/images folder
            let fileManager = FileManager.default
            var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            cacheURL.appendPathComponent(Constants.imageCacheFolderName, isDirectory: true)

            let calendar = Calendar(identifier: .iso8601)

            do {
                /// Get image files from cache directory
                let imagesArray = try fileManager.contentsOfDirectory(
                    at: cacheURL,
                    includingPropertiesForKeys: [URLResourceKey.creationDateKey],
                    options: .skipsHiddenFiles
                )

                for imageURL in imagesArray {
                    /// Get elapsed time interval
                    let resource = try imageURL.resourceValues(forKeys: [URLResourceKey.creationDateKey])
                    let interval = DateTimeManager.intervalBetweenDatesWithDayPrecision(calendar: calendar,
                                                                                        from: resource.creationDate!, to: Date())

                    /// Delete image file if time limit exceeded
                    if interval.day! > Constants.imageCacheFileLifeDurationDays {
                        try fileManager.removeItem(at: imageURL)
                    }
                }

            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//
//  CacheAPI.swift
//  RSSNews
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A class for operations with cache
class CacheRepository {

    /// Singleton
    static let instance = CacheRepository()

    private init() {
    }

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
            cacheURL.appendPathComponent(Constants.Image.cacheFolderName.rawValue, isDirectory: true)

            do {

                /// Check directory existence
                if !fileManager.fileExists(atPath: cacheURL.path) {
                    try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: false, attributes: nil)
                }

                /// Save file
                cacheURL.appendPathComponent(Cryptography.MD5(from: imageName) + Constants.Image.fileExtension.rawValue)
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
        let imageUrl = FileManagerHelper.getCachedImageUrlByName(fileName: imageName, fileExtension: Constants.Image.fileExtension.rawValue)
        return FileManager.default.fileExists(atPath: imageUrl.path)
    }

    /// Gets image from the cache folder
    ///
    /// - Parameters:
    ///   - imageName: Image name
    ///   - handler: Handler for getting result asynchronously
    func getImageFromCache(imageFileName imageName: String, completionHandler handler: @escaping (Data?) -> Void) {

        /// Asyncronously get the image from cache
        DispatchQueue.global(qos: .utility).async {
            let imageUrl = FileManagerHelper.getCachedImageUrlByName(
                fileName: imageName,
                fileExtension: Constants.Image.fileExtension.rawValue)

            let imageContent = try? Data(contentsOf: imageUrl)

            /// Return the image content to the UI on main thread
            DispatchQueue.main.async {
                handler(imageContent)
            }

        }

    }

}

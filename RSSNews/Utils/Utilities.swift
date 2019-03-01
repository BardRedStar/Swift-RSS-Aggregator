//
//  Utilities.swift
//  RSSNews
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A class for helping with file system operations
public class FileManagerHelper {

    /// Gets URL of file in the Caches/images folder
    ///
    /// - Parameters:
    ///   - fileName: File name
    ///   - fileExtension: File extension
    /// - Returns: URL of file
    public static func getCachedImageUrlByName(fileName: String, fileExtension: String) -> URL {
        let fileManager = FileManager.default
        var fileUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        fileUrl.appendPathComponent(Constants.imageCacheFolderName, isDirectory: true)
        fileUrl.appendPathComponent(fileName + fileExtension)
        return fileUrl
    }
}

//
//  Utilities.swift
//  RSSNews
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

public class FileManagerHelper {
    public static func getCachedImageUrlByName(fileName: String, fileExtension: String) -> URL {
        let fileManager = FileManager.default
        var fileUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        fileUrl.appendPathComponent("images", isDirectory: true)
        fileUrl.appendPathComponent(fileName + fileExtension)
        return fileUrl
    }
}

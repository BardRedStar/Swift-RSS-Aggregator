//
//  Crytography.swift
//  RSSNews
//
//  Created by User on 26/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import CommonCrypto

class Cryptography {

    public static func MD5(from string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let tempData = string.data(using: String.Encoding.utf8) {
            _ = tempData.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(tempData.count), &digest)
            }
        }

        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

//
//  RemoteAPI.swift
//  RSSNews
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import Alamofire

/// A class for executing HTTP request to remote API
class NetworkRepository {

    /// Singleton
    static let instance = NetworkRepository()

    private init() {
    }

    /// Hardcoded params
    let params: [String: Any] = [
        "sources": "techcrunch"
    ]

    /// Hardcoded headers
    let headers: [String: String] = [
        "Authorization": "Basic " + Constants.apiKey
    ]

    /// Creates a HTTP request to API to get last news
    func loadNewsFromSource(completionHandler handler: @escaping (Result<Data>) -> Void) {

        /// Request
        Alamofire.request(Constants.apiUrl, parameters: params, headers: headers)
            .validate()
            .responseData { responseData -> Void in
                handler(responseData.result)
            }
    }

    /// Gets image by URL
    ///
    /// - Parameters:
    ///   - imageUrl: URL to get image by
    ///   - completionHandler: Handler to get result asycronously
    func getImageByUrl(url imageUrl: String,
                       completionHandler handler: @escaping (Result<Data>) -> Void) {
        Alamofire.request(imageUrl)
            .validate()
            .responseData { (response) in
                handler(response.result)
            }

    }

}

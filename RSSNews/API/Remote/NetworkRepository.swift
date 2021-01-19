//
//  RemoteAPI.swift
//  RSSNews
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import Alamofire
import Combine

/// A class for executing HTTP request to remote API
class NetworkRepository {

    /// Singleton
    static let instance = NetworkRepository()

    private init() {
    }

    /// Default params
    var params: [String: Any] = ["sources": "techcrunch"]

    /// Hardcoded headers
    let headers: HTTPHeaders = HTTPHeaders([
        "Authorization": "Basic " + Constants.apiKey
    ])

    /// Creates a HTTP request to API to get last news
    ///
    /// - Parameters:
    ///   - source: Source ID of news source
    ///   - completionHandler: Completion handler to throw result
    func loadNewsFromSource(source: String) {

        params["sources"] = source
        params["apiKey"] = Constants.apiKey
        /// Request
        AF.request(Constants.apiUrl, method: .get, parameters: params).validate().publishData()
    }

    /// Gets image by URL
    ///
    /// - Parameters:
    ///   - imageUrl: URL to get image by
    ///   - completionHandler: Handler to get result asycronously
    func imageByUrl(url imageUrl: String) {
        AF.request(imageUrl).validate().publishData()
    }

}

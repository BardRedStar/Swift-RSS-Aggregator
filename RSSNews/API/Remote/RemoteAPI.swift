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
class RemoteAPI {

    /// Singleton
    static let instance = RemoteAPI()

    private init() {
    }

    /// Hardcoded params
    let params: [String: Any] = [
        "sources": "techcrunch"
    ]

    /// Hardcoded headers
    let headers: [String: String] = [
        "Authorization": "Basic 5592af9332c14f9080c0d9132bf1efee"
    ]

    /// Creates a HTTP request to API to get last news
    func loadNewsFromSource(completionHandler handler: @escaping (NewsEntity?) -> Void) {

        /// Request
        Alamofire.request("https://newsapi.org/v2/top-headlines", parameters: params, headers: headers)
            .validate()
            .responseString { responseString -> Void in
                switch responseString.result {
                case .success(let value):

                    let newsEntity: NewsEntity? = try? JSONDecoder().decode(NewsEntity.self, from: Data(value.utf8))

                    handler(newsEntity)

                case .failure(let error):
                    print("Remote API error:", error, separator: " ")
                }
            }
    }

    /// Gets image by URL
    ///
    /// - Parameters:
    ///   - imageUrl: URL to get image by
    ///   - completionHandler: Handler to get result asycronously
    func getImageByUrl(url imageUrl: String, completionHandler handler: @escaping (Data) -> Void) {
        Alamofire.request(imageUrl)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    handler(data)
                case .failure(let error):
                    print(error)
                }
            }

    }

}

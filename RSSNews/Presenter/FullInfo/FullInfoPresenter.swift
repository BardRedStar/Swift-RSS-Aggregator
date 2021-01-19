//
//  FullInfoPresenter.swift
//  RSSNews
//
//  Created by User on 06/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A protocol to implement full info screen presenter functions according to MVP architecture
protocol FullInfoViewPresenter {

    /// - Parameter view: Settings view to bind
    init(view: FullInfoView)

    /// Asynchronously gets the image by URL
    ///
    /// - Parameters:
    ///   - imageUrl: URL to image
    ///   - completionHandler: Callback handler to get request result
    func newsImageByUrl(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void)
}

/// A class for implementing full info screen presenter functions
class FullInfoPresenter: FullInfoViewPresenter {

    unowned let view: FullInfoView

    required init(view: FullInfoView) {
        self.view = view
    }

    func newsImageByUrl(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void) {

        let name = Cryptography.MD5(from: imageUrl)
        let cacheApiInstance = CacheRepository.instance

        if cacheApiInstance.isImageExists(imageFileName: name) {
            cacheApiInstance.imageFromCache(imageFileName: name, completionHandler: { data in
                handler(data != nil ? UIImage(data: data!)! : UIImage(named: Constants.resourcesDefaultIconName)!)
            })
        } else {
            NetworkRepository.instance.imageByUrl(url: imageUrl)
//            , completionHandler: { result in
//                switch result {
//                case .success(let value):
//                    cacheApiInstance.saveImageInCache(imageName: imageUrl, content: value)
//                    handler(UIImage(data: value)!)
//                case .failure(let error):
//                    self.view.showErrorMessage(message: error.localizedDescription)
//                }
//            })
        }
    }

}

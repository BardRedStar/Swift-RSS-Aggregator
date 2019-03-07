//
//  FullInfoPresenter.swift
//  RSSNews
//
//  Created by User on 06/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

protocol FullInfoViewPresenter {

    init(view: FullInfoView)

    func newsImageByUrl(from imageUrl: String, completionHandler handler: @escaping (UIImage) -> Void)
}

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
            NetworkRepository.instance.imageByUrl(url: imageUrl, completionHandler: { result in
                switch result {
                case .success(let value):
                    cacheApiInstance.saveImageInCache(imageName: imageUrl, content: value)
                    handler(UIImage(data: value)!)
                case .failure(let error):
                    self.view.showErrorMessage(message: error.localizedDescription)
                }
            })
        }
    }

}

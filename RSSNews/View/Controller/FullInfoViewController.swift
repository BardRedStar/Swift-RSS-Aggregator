//
//  FullInfoViewController.swift
//  RSSNews
//
//  Created by User on 06/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit
import Reusable

protocol FullInfoView: class {

    func showErrorMessage(message: String)

}

class FullInfoViewController: UIViewController, FullInfoView, StoryboardSceneBased {

    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet private weak var infoNewsTitleLabel: UILabel!

    @IBOutlet private weak var infoNewsContentLabel: UILabel!

    @IBOutlet private weak var infoNewsImageView: UIImageView!

    @IBOutlet private weak var infoNewsDateLabel: UILabel!

    @IBOutlet private weak var infoNewsAuthorLabel: UILabel!

    @IBOutlet private weak var infoNewsSourceButton: UIButton!

    var infoNewsItem: NewsItem!

    private var fullInfoViewPresenter: FullInfoViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        fullInfoViewPresenter = FullInfoPresenter(view: self)

        setDefaultValues()
    }

    private func setDefaultValues() {

        infoNewsTitleLabel.text = infoNewsItem.title
        infoNewsContentLabel.text = infoNewsItem.content
        infoNewsDateLabel.text = infoNewsItem.date
        infoNewsAuthorLabel.text = "by " + infoNewsItem.author
        infoNewsSourceButton.setTitle("View on " + infoNewsItem.sourceName, for: UIControl.State.normal)

        fullInfoViewPresenter.newsImageByUrl(from: infoNewsItem.imageUrl, completionHandler: { (image) in
            self.infoNewsImageView.image = image
        })
    }

    private func updateConstraints() {
        infoNewsTitleLabel.layoutIfNeeded()
        infoNewsContentLabel.layoutIfNeeded()
        infoNewsDateLabel.layoutIfNeeded()
        infoNewsAuthorLabel.layoutIfNeeded()
        infoNewsSourceButton.layoutIfNeeded()
        infoNewsImageView.layoutIfNeeded()
    }

    @IBAction private func newsSourceButtonDidClick(_ sender: UIButton) {

        guard let url = URL(string: infoNewsItem.sourceUrl) else {
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func showErrorMessage(message: String) {
        Toast.show(view: self.view, message: message, duration: 2.0)
    }
}
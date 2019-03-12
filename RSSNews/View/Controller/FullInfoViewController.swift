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

/// A protocol for linking actions with presenter
protocol FullInfoView: class {

    /// Shows the error message in Toast
    ///
    /// - Parameter message: Message to show
    func showErrorMessage(message: String)

}

/// A class for showing full news information
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

    private let transition = PopAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

        fullInfoViewPresenter = FullInfoPresenter(view: self)

        setUpPopAnimation()
        setDefaultValues()
    }

    /// Sets up the pop animation
    private func setUpPopAnimation() {
        transition.dismissCompletion = {
            self.infoNewsImageView.isHidden = false
        }
    }

    /// Sets default values to controls
    private func setDefaultValues() {

        infoNewsTitleLabel.text = infoNewsItem.title
        infoNewsContentLabel.text = infoNewsItem.content
        infoNewsDateLabel.text = infoNewsItem.date
        infoNewsAuthorLabel.text = "by " + infoNewsItem.author
        infoNewsSourceButton.setTitle("View on " + infoNewsItem.sourceName, for: UIControl.State.normal)

        infoNewsImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))

        fullInfoViewPresenter.newsImageByUrl(from: infoNewsItem.imageUrl, completionHandler: { (image) in
            self.infoNewsImageView.image = image
        })
    }

    @IBAction private func newsSourceButtonDidClick(_ sender: UIButton) {

        guard let url = URL(string: infoNewsItem.sourceUrl) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func showErrorMessage(message: String) {
        Toast.show(view: self.view, message: message, duration: 2.0)
    }
}

/// An extension for making the pop up animation
extension FullInfoViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.originFrame = infoNewsImageView.superview!.convert(infoNewsImageView.frame, to: nil)

        transition.presenting = true
        infoNewsImageView.isHidden = true

        return transition
    }

    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {

        let imageDetails = FullImageViewController.instantiate()
        imageDetails.fullImageContent = self.infoNewsImageView.image
        imageDetails.transitioningDelegate = self
        present(imageDetails, animated: true, completion: {
            self.infoNewsImageView.isHidden = false
        })
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.presenting = false
        return transition
    }

}

//
//  FullImageViewController.swift
//  RSSNews
//
//  Created by User on 28/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit
import Reusable

/// A controller class for full image showing
class FullImageViewController: UIViewController, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, StoryboardSceneBased {

    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet private weak var fullImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!

    weak var fullImageContent: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fullImageView.image = fullImageContent

        fullImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {

        if let view = recognizer.view {

            let translation = recognizer.translation(in: self.view)

            /// Set translation
            view.center.y += translation.y
            self.view.alpha = 1.0 - abs(view.center.y - self.view.center.y) / self.view.center.y

            if recognizer.state == .ended {

                /// Check image center in padding critical bounds
                let paddingZonePart = Constants.swipeImageCriticalPaddingZonePart
                let rect = self.view.frame
                let padding = rect.size.height * CGFloat(paddingZonePart)

                if view.center.y >= self.view.frame.height - padding || view.center.y <= padding {
                    presentingViewController?.dismiss(animated: false, completion: nil)
                }

                /// Check maximum velocity
                if abs(recognizer.velocity(in: self.view).y) >= Constants.swipeImageMaximumVelocity {
                    presentingViewController?.dismiss(animated: false, completion: nil)
                }

                /// If view was not dismissed, bring it back to center
                UIView.animate(withDuration: Constants.swipeImageBackDuration, delay: 0.0, options: .curveEaseOut, animations: {
                    view.center.y = self.view.center.y
                    self.view.alpha = 1.0
                })
            }

            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return fullImageView
    }
}

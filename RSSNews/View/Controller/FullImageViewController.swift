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
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {

            view.center.y += translation.y
            self.view.alpha = 1.0 - abs(view.center.y - self.view.center.y) / self.view.center.y

            if recognizer.state == .ended {

                let location = recognizer.location(in: self.view)
                print("\(location.y)")

                let paddingZonePart = 0.2
                let rect = self.view.frame
                let padding = rect.size.height * CGFloat(paddingZonePart)

                if view.center.y >= self.view.frame.height - padding || view.center.y <= padding {
                    presentingViewController?.dismiss(animated: false, completion: nil)
                }

                if abs(recognizer.velocity(in: self.view).y) >= 2000 {
                    presentingViewController?.dismiss(animated: false, completion: nil)
                }

                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
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

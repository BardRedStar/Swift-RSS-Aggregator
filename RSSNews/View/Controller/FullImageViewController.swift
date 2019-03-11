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

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fullImageView.image = fullImageContent

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
    }

    @IBAction private func didTapView(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return fullImageView
    }
}

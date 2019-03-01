//
//  FullImageViewController.swift
//  RSSNews
//
//  Created by User on 28/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A controller class for full image showing
class FullImageViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet private weak var fullImageView: UIImageView!

    weak var fullImageContent: UIImage?

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
}

//
//  Toast.swift
//  RSSNews
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A class for creating Toast control
class Toast {

    /// Shows message in Toast
    ///
    /// - Parameters:
    ///   - view: View to resize and attach Toast
    ///   - message: Message string to show
    ///   - duration: Toast lifetime
    class func show(view: UIView, message: String, duration: Double) {

        let toastTextView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: 0))

        toastTextView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastTextView.textColor = UIColor.white
        toastTextView.textAlignment = .center
        toastTextView.text = message
        toastTextView.frame.size.height = toastTextView.intrinsicContentSize.height
        toastTextView.sizeToFit()

        /// Put it to start position
        toastTextView.frame.origin.x = view.frame.size.width / 2 - toastTextView.frame.size.width / 2
        toastTextView.frame.origin.y = view.frame.size.height

        /// Set opacity and corner bounds
        toastTextView.alpha = 0.0
        toastTextView.layer.cornerRadius = toastTextView.frame.size.height / 4
        toastTextView.clipsToBounds = true

        view.addSubview(toastTextView)
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseInOut, animations: {

            toastTextView.alpha = 1.0
            toastTextView.frame.origin.y -= view.frame.size.height / 15 + toastTextView.frame.size.height

        }, completion: { isCompleted in

            UIView.animate(withDuration: 0.7, delay: duration, options: .curveEaseInOut, animations: {

                toastTextView.alpha = 1.0
                toastTextView.frame.origin.y += view.frame.size.height / 10 + toastTextView.frame.size.height

            }, completion: { isCompleted in
                toastTextView.removeFromSuperview()
            })
        })

    }
}

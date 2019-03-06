//
//  PopAnimator.swift
//  RSSNews
//
//  Created by User on 28/02/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A class for animating full picture opening
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presenting = true
    var originFrame = CGRect.zero

    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.popAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fullImageView = presenting ? toView : transitionContext.view(forKey: .from)!

        /// Get start and end frames to calculate rect sizes
        let initialFrame = presenting ? originFrame : fullImageView.frame
        let finalFrame = presenting ? fullImageView.frame : originFrame

        /// Get scale factors to animate scaling
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            fullImageView.transform = scaleTransform
            fullImageView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            fullImageView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fullImageView)

        /// Animate
        UIView.animate(withDuration: Constants.popAnimationDuration,
                       delay: Constants.popAnimationDelay,
                       animations: {
                        fullImageView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        fullImageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}

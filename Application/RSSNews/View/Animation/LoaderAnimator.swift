//
//  LoadingAnimator.swift
//  RSSNews
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A class for creating loading animation
class LoaderAnimator {

    private static var loaderView: UIView?

    /// Move directions
    enum MoveDirection {
        case right
        case left
        case up
        case down

        /// Calculated enum value
        var value: (x: Int, y: Int) {
            switch self {
            case .right:
                return (1, 0)
            case .left:
                return (-1, 0)
            case .up:
                return (0, -1)
            case .down:
                return (0, 1)
            }
        }
    }

    /// Shapes
    enum Shape {
        case circle
        case square
    }

    /// Base colors
    enum Colors {
        case red
        case orange
        case blue
        case green

        /// Calculated enum value
        var value: UIColor {
            switch self {
            case .red:
                return UIColor(red: 239 / 255, green: 83 / 255, blue: 80 / 255, alpha: 1.0)
            case .orange:
                return UIColor(red: 255 / 255, green: 167 / 255, blue: 38 / 255, alpha: 1.0)
            case .blue:
                return UIColor(red: 66 / 255, green: 165 / 255, blue: 245 / 255, alpha: 1.0)
            case .green:
                return UIColor(red: 102 / 255, green: 187 / 255, blue: 106 / 255, alpha: 1.0)
            }
        }
    }

    /// Initializes the loading animation using Keyframes
    class func initLoadingAnimation() {

        var animations: [CAKeyframeAnimation] = []

        /// Change color
        let colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
        colorKeyframeAnimation.values = [Colors.red.value.cgColor,
                                         Colors.green.value.cgColor,
                                         Colors.orange.value.cgColor,
                                         Colors.blue.value.cgColor,
                                         Colors.red.value.cgColor]
        colorKeyframeAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animations.append(colorKeyframeAnimation)

        /// Change shape
        let shapeKeyframeAnimation = CAKeyframeAnimation(keyPath: "cornerRadius")
        shapeKeyframeAnimation.values = [0.0, Constants.loaderSize / 2, 0.0, Constants.loaderSize / 2, 0.0]
        shapeKeyframeAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animations.append(shapeKeyframeAnimation)

        /// Change Position
        let positionKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let directions: [MoveDirection] = [.right, .down, .left, .up]
        var currentPoint = loaderView!.frame.origin
        var points: [CGPoint] = [currentPoint]

        for direction in directions {
            currentPoint.x += Constants.loaderSize * 2.0 * CGFloat(direction.value.x)
            currentPoint.y += Constants.loaderSize * 2.0 * CGFloat(direction.value.y)
            points.append(currentPoint)
        }

        positionKeyframeAnimation.values = points
        positionKeyframeAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animations.append(positionKeyframeAnimation)

        /// Make group of keys and bind
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 1.5
        group.repeatCount = 100
        loaderView!.layer.add(group, forKey: "loaderAnimation")

    }

    /// Creates loader view and animate it
    ///
    /// - Parameter view: View to attach loader
    class func showLoader(view: UIView) {

        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height

        if loaderView != nil {
            loaderView!.removeFromSuperview()
        }
        loaderView = UIView(frame: CGRect(x: viewWidth / 2 - Constants.loaderSize,
                                          y: viewHeight / 2 - Constants.loaderSize,
                                          width: Constants.loaderSize,
                                          height: Constants.loaderSize))

        loaderView!.backgroundColor = UIColor.red

        view.addSubview(loaderView!)

        initLoadingAnimation()

    }

    /// Stops (removes) loader
    class func stopLoader() {
        if loaderView != nil {
            loaderView!.removeFromSuperview()
        }
    }
}

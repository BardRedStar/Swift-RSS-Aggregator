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

    /// Starts transform animation
    ///
    /// - Parameters:
    ///   - direction: Direction to move loader view
    ///   - shape: Shape to morph view
    ///   - color: Color to set
    ///   - completion: Completion handler
    class func startTransformation(direction: MoveDirection, shape: Shape, color: Colors, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: Constants.loaderTransformDuration, delay: 0.0, animations: {

            switch shape {
            case .circle:
                loaderView!.layer.cornerRadius += Constants.loaderSize / 2
            case .square:
                loaderView!.layer.cornerRadius -= Constants.loaderSize / 2
            }

            loaderView!.frame.origin.x += Constants.loaderSize * 2.0 * CGFloat(direction.value.x)
            loaderView!.frame.origin.y += Constants.loaderSize * 2.0 * CGFloat(direction.value.y)

            loaderView!.backgroundColor = color.value

        }, completion: completion)
    }

    /// Emits the loader animation recursively
    class func startLoadingAnimation() {
        startTransformation(direction: .right, shape: .circle, color: .green, completion: { (isCompleted) in
            startTransformation(direction: .down, shape: .square, color: .orange, completion: { (isCompleted) in
                startTransformation(direction: .left, shape: .circle, color: .blue, completion: { (isCompleted) in
                    startTransformation(direction: .up, shape: .square, color: .red, completion: { (isCompleted) in
                        startLoadingAnimation()
                    })
                })
            })
        })
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

        startLoadingAnimation()
    }

    /// Stops (removes) loader
    class func stopLoader() {
        if loaderView != nil {
            loaderView!.removeFromSuperview()
        }
    }
}

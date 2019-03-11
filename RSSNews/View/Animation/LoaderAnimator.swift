//
//  LoadingAnimator.swift
//  RSSNews
//
//  Created by User on 07/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

class LoaderAnimator {

    private static var loaderView: UIView?

    enum MoveDirection {
        case right
        case left
        case up
        case down

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

    enum Shape {
        case circle
        case square
    }

    enum Colors {
        case red
        case orange
        case blue
        case green

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

    class func startTransformation(direction: MoveDirection, shape: Shape, color: Colors, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0.1, animations: {

            switch shape {
            case .circle:
                loaderView!.layer.cornerRadius += 10.0
            case .square:
                loaderView!.layer.cornerRadius -= 10.0
            }

            loaderView!.frame.origin.x += CGFloat(direction.value.x * 20 * 2)
            loaderView!.frame.origin.y += CGFloat(direction.value.y * 20 * 2)

            loaderView!.backgroundColor = color.value

        }, completion: completion)
    }

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

    class func showLoader(view: UIView) {

        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height

        if loaderView != nil {
            loaderView!.removeFromSuperview()
        }
        loaderView = UIView(frame: CGRect(x: viewWidth / 2 - 20, y: viewHeight / 2 - 20, width: 20, height: 20))
        loaderView!.backgroundColor = UIColor.red

        view.addSubview(loaderView!)

        startLoadingAnimation()
    }

    class func stopLoader() {
        if loaderView != nil {
            loaderView!.removeFromSuperview()
        }
    }
}

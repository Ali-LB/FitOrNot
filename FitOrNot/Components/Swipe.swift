//
//  Swipe.swift
//  FitOrNot
//
//  Created by Ali Farhat on 11/7/23.
//

import Foundation
import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

/*
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if AppState.shared.swipeEnabled {
            return viewControllers.count > 1
        }
        return false
    }
    
}*/

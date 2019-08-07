//
//  WidgetsOwnerProtocol.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/5.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

protocol WidgetsOwnerProtocol {
    func startPreview(for: UIView)
    func updatePreview(percent: CGFloat)
    func finishPreview()
    func cancelPreview()
}

extension WidgetsOwnerProtocol {
    func startPreview(for forView: UIView) { }
    func updatePreview(percent: CGFloat) { }
    func finishPreview() { }
    func cancelPreview() { }
}


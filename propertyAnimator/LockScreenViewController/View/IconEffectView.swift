//
//  IconEffectView.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class IconEffectView: UIVisualEffectView {

    convenience init(blur: UIBlurEffect.Style) {
        self.init(effect: UIBlurEffect(style: blur))
        
        clipsToBounds = true
        layer.cornerRadius = 16
        
        let label = UILabel()
        label.text = "custiomize actions..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.center = CGPoint(x: 90, y: 30)
        contentView.addSubview(label)
    }
}

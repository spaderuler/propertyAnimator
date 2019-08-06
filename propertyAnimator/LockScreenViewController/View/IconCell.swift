//
//  IconCell.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/2.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var animator: UIViewPropertyAnimator?
    override func awakeFromNib() {
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 12
    }
    
    func iconJiggle() {
        if let animator = animator, animator.isRunning {
            return
        }
       animator = AnimatorFactory.jiggle(view: icon)
    }
}

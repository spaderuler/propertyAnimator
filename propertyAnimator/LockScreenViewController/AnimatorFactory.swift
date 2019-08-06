//
//  AnimatorFactory.swift
//  UIViewPropertyAnimator
//
//  Created by donggua on 2019/8/5.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class AnimatorFactory: NSObject {

    
   static func jiggle(view: UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                    view.transform = CGAffineTransform(rotationAngle: -.pi/8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
                    view.transform = CGAffineTransform(rotationAngle: .pi/8)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 1, animations: {
                    view.transform = .identity
                })
            }, completion: nil)
        }, completion: { (_) in
            view.transform = .identity
        })
    }
    
    static func grow(effectView: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {
        effectView.contentView.alpha = 0
        effectView.transform = .identity
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            blurView.effect = UIBlurEffect(style: .dark)
            effectView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        animator.addCompletion { (position) in
            switch position {
            case .start:
                blurView.effect = nil
            case .end:
                blurView.effect = UIBlurEffect(style: .dark)
            default: break
            }
        }
     return animator
    }
    
    static func reset(frame: CGRect,effectView: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {
        return  UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
            effectView.frame = frame
            effectView.transform = .identity
            effectView.contentView.alpha = 0
            
            blurView.effect = nil
        })
    }
    
    static func complete(view: UIVisualEffectView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
            view.contentView.alpha = 1
            view.transform = .identity
            view.frame = CGRect(x: view.frame.minX - view.frame.minX/2.5,
                                y: view.frame.maxY - 140,
                                width: view.frame.width + 120,
                                height: 60)
        })
    }
    
}

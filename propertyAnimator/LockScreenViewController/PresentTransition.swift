//
//  PresentTransition.swift
//  propertyAnimator
//
//  Created by donggua on 2019/8/6.
//  Copyright © 2019年 wky. All rights reserved.
//

import UIKit

class PresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    var auxAnimations: (()->Void)?
    var auxAnimarionsCancel: (()->Void)?
    var context: UIViewControllerContextTransitioning?
    var animator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
     return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimator(using: transitionContext).startAnimation()
    }
    
    func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        toView.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
        toView.alpha = 0
        container.addSubview(toView)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        animator.addAnimations({
            toView.transform = CGAffineTransform(translationX: 0, y: 100)
        }, delayFactor: 0.15)
        animator.addAnimations({
            toView.alpha = 1
        }, delayFactor: 0.5)
        animator.addCompletion { (position) in
            switch position{
            case .end:
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            default:
                transitionContext.completeTransition(false)
                self.auxAnimarionsCancel?()
            }
        }
        
        if let auxAnimations = auxAnimations {
            animator.addAnimations(auxAnimations)
        }
        
        self.animator = animator
        self.context = transitionContext
        animator.addCompletion { (_) in
            self.animator = nil
            self.context = nil
        }
        animator.isUserInteractionEnabled = true
        return animator
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionAnimator(using:transitionContext)
    }
    
    func interruptTransition() {
        guard let context = context else {
            return
        }
        context.pauseInteractiveTransition()
        pause()
    }
    
}

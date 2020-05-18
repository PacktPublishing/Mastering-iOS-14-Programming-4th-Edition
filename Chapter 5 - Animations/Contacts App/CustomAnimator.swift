//
//  CustomAnimator.swift
//  Contacts App
//
//  Created by Chris Barker on 17/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject {

}

extension CustomAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
            
        }
        // 2
        let transitionContainer = transitionContext.containerView
        
        // 3
        var transform = CGAffineTransform.identity
        transform = transform.concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
        transform = transform.concatenating(CGAffineTransform(translationX: 0, y: -200))
        
        toViewController.view.transform = transform
        toViewController.view.alpha = 0
        
        // 4
        transitionContainer.addSubview(toViewController.view)
        
        // 5
        let animationTiming = UISpringTimingParameters( dampingRatio: 0.8,
                                                        initialVelocity: CGVector(dx: 1, dy: 0))
        
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: animationTiming)
        
        animator.addAnimations {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.alpha = 1
        }
        
        // 6
        animator.addCompletion { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // 7
        animator.startAnimation()
        
    }
    

}

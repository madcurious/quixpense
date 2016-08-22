//
//  CustomPickerPresentationAnimator.swift
//  Spare
//
//  Created by Matt Quiros on 15/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Duration.Animation
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) as? CustomPickerView
            else {
                return
        }
        
        // Initial values
        toView.layoutIfNeeded()
        toView.frame = transitionContext.finalFrameForViewController(toVC)
        toView.dimView.alpha = 0
        
        // Apparently, frame-based animations are more reliable than Autolayout.
        let destinationY = toView.bounds.size.height - toView.mainContainer.bounds.size.height
        let initialMainContainerFrame = CGRectMake(0, toView.bounds.size.height, toView.bounds.size.width, toView.mainContainer.bounds.size.height)
        toView.mainContainer.frame = initialMainContainerFrame
        var destinationFrame = initialMainContainerFrame
        destinationFrame.origin.y = destinationY
        
        containerView.addSubview(toView)
        
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            animations: {
                toView.dimView.alpha = 0.7
                toView.mainContainer.frame = destinationFrame
            },
            completion: { _ in
                let successful = transitionContext.transitionWasCancelled() == false
                if successful == false {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(successful)
        })
    }
    
}

//
//  CustomPickerPresentationAnimator.swift
//  Spare
//
//  Created by Matt Quiros on 15/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Duration.Animation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) as? CustomPickerView
            else {
                return
        }
        
        // Initial values
        toView.layoutIfNeeded()
        toView.frame = transitionContext.finalFrame(for: toVC)
        toView.dimView.alpha = 0
        
        // Apparently, frame-based animations are more reliable than Autolayout.
        let destinationY = toView.bounds.size.height - toView.mainContainer.bounds.size.height
        let initialMainContainerFrame = CGRect(x: 0, y: toView.bounds.size.height, width: toView.bounds.size.width, height: toView.mainContainer.bounds.size.height)
        toView.mainContainer.frame = initialMainContainerFrame
        var destinationFrame = initialMainContainerFrame
        destinationFrame.origin.y = destinationY
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                toView.dimView.alpha = 0.7
                toView.mainContainer.frame = destinationFrame
            },
            completion: { _ in
                let successful = transitionContext.transitionWasCancelled == false
                if successful == false {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(successful)
        })
    }
    
}

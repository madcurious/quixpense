//
//  CustomPickerDismissalAnimator.swift
//  Spare
//
//  Created by Matt Quiros on 15/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Duration.Animation
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) as? CustomPickerView
            else {
                return
        }
        
        var finalMainContainerFrame = fromView.mainContainer.frame
        finalMainContainerFrame.origin.y = fromView.bounds.size.height
        
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            animations: {
                fromView.dimView.alpha = 0
                fromView.mainContainer.frame = finalMainContainerFrame
            },
            completion: { _ in
                let successful = transitionContext.transitionWasCancelled() == false
                transitionContext.completeTransition(successful)
        })
    }
    
}

//
//  CustomPickerDismissalAnimator.swift
//  Spare
//
//  Created by Matt Quiros on 15/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Duration.Animation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) as? CustomPickerView
            else {
                return
        }
        
        var finalMainContainerFrame = fromView.mainContainer.frame
        finalMainContainerFrame.origin.y = fromView.bounds.size.height
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                fromView.dimView.alpha = 0
                fromView.mainContainer.frame = finalMainContainerFrame
            },
            completion: { _ in
                let successful = transitionContext.transitionWasCancelled == false
                transitionContext.completeTransition(successful)
        })
    }
    
}

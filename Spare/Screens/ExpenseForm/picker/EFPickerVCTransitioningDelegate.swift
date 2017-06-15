//
//  EFPickerVCTransitioningDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFPickerVCTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return _EFPickerVCPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return _EFPickerVCDismissalAnimator()
    }
    
}

fileprivate class _EFPickerVCPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    fileprivate func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) as? _EFPVCView
            else {
                return
        }
        
        transitionContext.containerView.addSubviewAndFill(toView)
        
        toView.dimView.alpha = 0
        toView.contentViewBottom.constant = -(toView.contentViewHeight.constant)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .layoutSubviews,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: { 
                                        toView.dimView.alpha = toView.dimViewMaxAlpha
                                        
                                        toView.contentViewBottom.constant = 0
                                        toView.setNeedsLayout()
                                        toView.layoutIfNeeded()
                                    })
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

fileprivate class _EFPickerVCDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    fileprivate func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) as? _EFPVCView
            else {
                return
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        fromView.dimView.alpha = 0.0
                        fromView.contentViewBottom.constant = -(fromView.contentViewHeight.constant)
                        fromView.setNeedsLayout()
                        fromView.layoutIfNeeded()
        },
                       completion: { _ in
                        let successful = transitionContext.transitionWasCancelled == false
                        transitionContext.completeTransition(successful)
        })
    }
    
}

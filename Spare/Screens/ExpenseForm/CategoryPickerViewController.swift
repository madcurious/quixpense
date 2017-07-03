//
//  CategoryPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

fileprivate let kTransitioningDelegate = CategoryPickerTransitioningDelegate()

class CategoryPickerViewController: UIViewController {
    
    class func present(from presenter: ExpenseFormViewController) {
        let picker = CategoryPickerViewController()
        picker.setCustomTransitioningDelegate(kTransitioningDelegate)
        presenter.present(picker, animated: true, completion: nil)
    }
    
    let customView = CategoryPickerView.instantiateFromNib()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        self.customView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

fileprivate class CategoryPickerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryPickerPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryPickerDismissalAnimator()
    }
    
}

fileprivate class CategoryPickerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Global.viewControllerTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) as? CategoryPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(toView)
        
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        toView.dimView.alpha = 0.0
        toView.stackViewBottom.constant = -(toView.stackView.bounds.size.height)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        
                        toView.dimView.alpha = 0.4
                        
                        toView.stackViewBottom.constant = 0
                        toView.setNeedsLayout()
                        toView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

fileprivate class CategoryPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Global.viewControllerTransitionAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) as? CategoryPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(fromView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        fromView.dimView.alpha = 0
                        
                        fromView.stackViewBottom.constant = -(fromView.stackView.bounds.size.height)
                        fromView.setNeedsLayout()
                        fromView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

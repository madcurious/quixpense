//
//  SlideUpPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 05/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

private let kSharedTransitioningDelegate = SlideUpPickerTransitioningDelegate()
private let kContentViewHeightWithKeyboard = UIScreen.main.nativeSize.height * 1 / 3
private let kContentViewHeightWithoutKeyboard = UIScreen.main.nativeSize.height * 3 / 5

class SlideUpPickerViewController: UIViewController {
    
    lazy var customView = SlideUpPickerView.instantiateFromNib()
    
    override func loadView() {
        self.customView.contentViewHeight.constant = kContentViewHeightWithoutKeyboard
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        customView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

@objc extension SlideUpPickerViewController {
    
    func handleTapOnDimView() {
        
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSValue as? TimeInterval
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration,
                       animations: {[unowned self] in
                        self.customView.contentViewHeight.constant = kContentViewHeightWithoutKeyboard
                        self.customView.contentViewBottom.constant = 0
                        self.customView.setNeedsLayout()
                        self.customView.layoutIfNeeded()
        })
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSValue as? TimeInterval
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration,
                       animations: {[unowned self] in
                        self.customView.contentViewHeight.constant = kContentViewHeightWithKeyboard
                        self.customView.contentViewBottom.constant = keyboardFrame.size.height
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
        })
    }
    
}

// MARK: Class functions
extension SlideUpPickerViewController {
    
    class func present(_ picker: SlideUpPickerViewController, from presenter: ExpenseFormViewController) {
        picker.setCustomTransitioningDelegate(kSharedTransitioningDelegate)
        presenter.present(picker, animated: true, completion: nil)
    }
    
    /// Returns a `UINavigationController` that is internally customized to fix a layout issue in iOS,
    /// where pressing the back button from `NewClassifierViewController` doesn't properly resize
    /// the root view controller in the picker.
    class func makeInternalNavigationController() -> UINavigationController {
        class InternalNavigationController: BaseNavBarVC {
            override func viewDidLoad() {
                super.viewDidLoad()
                self.interactivePopGestureRecognizer?.isEnabled = false
            }
            override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
                self.view.frame.size.height = kContentViewHeightWithoutKeyboard // layout fix
            }
        }
        
        let internalNavigationController = InternalNavigationController(nibName: nil, bundle: nil)
        return internalNavigationController
    }
    
}

// MARK: - SlideUpPickerTransitioningDelegate
fileprivate class SlideUpPickerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpPickerPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpPickerDismissalAnimator()
    }
    
}

// MARK: - SlideUpPickerPresentationAnimator
fileprivate class SlideUpPickerPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) as? SlideUpPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(toView)
        
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        toView.dimView.alpha = 0.0
        toView.contentViewBottom.constant = -(toView.contentViewHeight.constant)
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        toView.dimView.alpha = 0.4
                        toView.contentViewBottom.constant = 0
                        toView.setNeedsLayout()
                        toView.layoutIfNeeded()
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(cancelled )
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
}

fileprivate class SlideUpPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) as? SlideUpPickerView
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubviewsAndFill(fromView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        fromView.dimView.alpha = 0
                        fromView.contentViewBottom.constant = -(fromView.contentViewHeight.constant)
                        fromView.setNeedsLayout()
                        fromView.layoutIfNeeded()
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
}

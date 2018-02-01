//
//  DatePickerViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 01/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    let datePickerView = DatePickerView(frame: .zero)
    var doneAction: ((Date) -> Void)?
    
    init(initialSelection: Date?, doneAction: ((Date) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        datePickerView.pickerView.date = initialSelection ?? Date()
        self.doneAction = doneAction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func loadView() {
        view = datePickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerView.cancelBarButtonItem.target = self
        datePickerView.cancelBarButtonItem.action = #selector(handleTapOnCancelBarButtonItem)
        
        datePickerView.doneBarButtonItem.target = self
        datePickerView.doneBarButtonItem.action = #selector(handleTapOnDoneBarButtonItem)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCancelBarButtonItem))
        datePickerView.dimView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate static let sharedTransitioningDelegate = TransitioningDelegate()
    
    class func present(from presenter: UIViewController, initialSelection: Date?, doneAction: ((Date) -> Void)?) {
        let vc = DatePickerViewController(initialSelection: initialSelection, doneAction: doneAction)
        vc.datePickerView.dimView.alpha = 0.6
        vc.transitioningDelegate = DatePickerViewController.sharedTransitioningDelegate
        vc.modalPresentationStyle = .custom
        presenter.present(vc, animated: true, completion: nil)
    }
    
}

@objc fileprivate extension DatePickerViewController {
    
    func handleTapOnCancelBarButtonItem() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneBarButtonItem() {
        doneAction?(datePickerView.pickerView.date)
        dismiss(animated: true, completion: nil)
    }
    
}

fileprivate class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalAnimator()
    }
    
}

fileprivate class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let datePickerView = transitionContext.view(forKey: .to) as? DatePickerView
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.addSubviewAndFill(datePickerView)
        
        datePickerView.setNeedsLayout()
        datePickerView.layoutIfNeeded()
        datePickerView.dimView.alpha = 0
        datePickerView.stackViewBottom.constant = -(datePickerView.stackView.bounds.size.height)
        datePickerView.setNeedsLayout()
        datePickerView.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.layoutSubviews],
                       animations: {
                        datePickerView.dimView.alpha = 0.6
                        datePickerView.stackViewBottom.constant = 0
                        datePickerView.setNeedsLayout()
                        datePickerView.layoutIfNeeded()
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })
    }
    
}

fileprivate class DismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let datePickerView = transitionContext.view(forKey: .from) as? DatePickerView
            else {
                return
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.layoutSubviews],
                       animations: {
                        datePickerView.dimView.alpha = 0
                        datePickerView.stackViewBottom.constant = -(datePickerView.stackView.bounds.size.height)
                        datePickerView.setNeedsLayout()
                        datePickerView.layoutIfNeeded()
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })
    }
    
}

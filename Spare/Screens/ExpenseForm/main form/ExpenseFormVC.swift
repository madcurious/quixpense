//
//  ExpenseFormVC.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseFormVC: UIViewController {
    
    let customView = _EFVCView.instantiateFromNib()
    let pickerTransitioningDelegate = EFPickerVCTransitioningDelegate()
    
    override var formScrollView: UIScrollView {
        return self.customView.scrollView
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addFormScrollViewKeyboardObservers()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapRecognizer)
        
        self.customView.dateBox.fieldButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    func handleTapOnDateButton() {
        let picker = EFDatePickerVC(nibName: nil, bundle: nil)
        picker.setCustomTransitioningDelegate(self.pickerTransitioningDelegate)
        self.present(picker, animated: true, completion: nil)
    }
    
    override func performAdditionalKeyboardWillShowTasks(notification: Notification, bottomInset: CGFloat) {
        guard self.customView.notesBox.textView.isFirstResponder,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        var adjustedBottomInset = bottomInset
        if UIApplication.shared.statusBarFrame.size.height == 40 {
//            adjustedBottomInset += tabBar.bounds.size.height - 6
            adjustedBottomInset += UIApplication.shared.statusBarFrame.size.height
        } else if let navigationBar = self.navigationController?.navigationBar {
            adjustedBottomInset += navigationBar.bounds.size.height
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       animations: {
                        self.formScrollView.contentOffset = CGPoint(x: 0, y: self.customView.stackView.bounds.size.height - adjustedBottomInset - self.customView.notesBox.bounds.size.height)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

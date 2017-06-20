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
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapRecognizer)
        
        self.customView.dateBox.fieldButton.addTarget(self, action: #selector(handleTapOnDateButton), for: .touchUpInside)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.customView.scrollView.delegate = self
        
        self.customView.categoryBox.fieldButton.addTarget(self, action: #selector(handleTapOnCategoryButton), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ExpenseFormVC {
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    @objc func handleTapOnDateButton() {
        let picker = EFDatePickerVC(nibName: nil, bundle: nil)
        picker.setCustomTransitioningDelegate(self.pickerTransitioningDelegate)
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func handleTapOnCategoryButton() {
        let picker = EFCategoryPickerVC(nibName: nil, bundle: nil)
        picker.setCustomTransitioningDelegate(self.pickerTransitioningDelegate)
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        var bottomInset = keyboardFrame.height
        if let tabBar = self.tabBarController?.tabBar {
            bottomInset -= tabBar.bounds.size.height
        }
        
        let shouldAdjustOffset = self.customView.notesBox.textView.isFirstResponder
        let convertedOrigin = UIApplication.shared.keyWindow!.rootViewController!.view.convert(self.customView.stackView.frame.origin, from: self.customView.stackView.superview!)
        let inset = (convertedOrigin.y + self.customView.stackView.bounds.size.height) - keyboardFrame.origin.y
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       animations: {[unowned self] in
                        self.customView.scrollViewBottom.constant = bottomInset
                        self.customView.setNeedsLayout()
                        self.customView.layoutIfNeeded()
                        
                        if shouldAdjustOffset {
                            self.customView.scrollView.contentOffset = CGPoint(x: 0, y: inset)
                        }
        })
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       animations: {[unowned self] in
                        self.customView.scrollViewBottom.constant = 0
                        self.customView.setNeedsLayout()
                        self.customView.layoutIfNeeded()
        })
    }
    
}

extension ExpenseFormVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offset: \(scrollView.contentOffset)")
    }
    
}

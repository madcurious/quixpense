//
//  ExpenseFormViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseFormViewController: UIViewController {
    
    let customView = ExpenseFormView.instantiateFromNib()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(
            .cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(
            .done, target: self, action: #selector(handleTapOnDoneButton))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self, selector: #selector(handleKeyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(
            self, selector: #selector(handleKeyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    func hasUnsavedChanges() -> Bool {
        guard let amountText = self.customView.amountFieldView.textField.text,
            let categoryText = self.customView.categoryFieldView.textField.text,
            let tagText = self.customView.tagFieldView.textField.text,
            amountText.isEmpty == false || categoryText.isEmpty == false || tagText.isEmpty == false
            else {
                return false
        }
        return true
    }
    
    func resetFields() {
        self.customView.amountFieldView.textField.text = nil
        self.customView.dateFieldView.setToCurrentDate()
        self.customView.categoryFieldView.textField.text = nil
        self.customView.tagFieldView.textField.text = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions

extension ExpenseFormViewController {
    
    @objc func handleTapOnView() {
        self.customView.endEditing(true)
    }
    
    @objc func handleTapOnCancelButton() {
        
    }
    
    @objc func handleTapOnDoneButton() {
        
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue as? CGRect
//            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSValue as? NSNumber as? Double
            else {
                return
        }
        
        let newInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height - self.tabBarController!.tabBar.bounds.size.height, 0)
        self.customView.scrollView.contentInset = newInsets
        self.customView.scrollView.scrollIndicatorInsets = newInsets
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        self.customView.scrollView.contentInset = .zero
        self.customView.scrollView.scrollIndicatorInsets = .zero
    }
    
}



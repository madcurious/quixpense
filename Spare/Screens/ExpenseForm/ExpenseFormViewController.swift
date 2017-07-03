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
    let suggestionList = SuggestionsViewController()
    let suggestionListHeight: CGFloat = {
        if UIScreen.main.nativeSize.height == 568 {
            return CGFloat(44 * 2)
        }
        return CGFloat(44 * 3)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = BarButtonItems.make(
            .cancel, target: self, action: #selector(handleTapOnCancelButton))
        self.navigationItem.rightBarButtonItem = BarButtonItems.make(
            .done, target: self, action: #selector(handleTapOnDoneButton))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleKeyboardWillShow(_:)),
                                       name: Notification.Name.UIKeyboardWillShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleKeyboardWillHide(_:)),
                                       name: Notification.Name.UIKeyboardWillHide,
                                       object: nil)
        
        let textFieldsWithSuggestions = [self.customView.categoryFieldView.textField, self.customView.tagFieldView.textField]
        for textField in textFieldsWithSuggestions {
            notificationCenter.addObserver(self,
                                           selector: #selector(handleTextFieldTextDidChange),
                                           name: Notification.Name.UITextFieldTextDidChange,
                                           object: textField)
            notificationCenter.addObserver(self,
                                           selector: #selector(handleTextFieldDidEndEditing(_:)),
                                           name: Notification.Name.UITextFieldTextDidEndEditing,
                                           object: textField)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.customView.addGestureRecognizer(tapGestureRecognizer)
        
        self.customView.scrollView.delegate = self
        
        self.customView.categoryFieldView.textField.delegate = self
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
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSValue as? NSNumber as? Double
            else {
                return
        }
        
        var contentOffsetY = CGFloat(0)
        let minimumSuggestionListY = UIScreen.main.nativeSize.height - keyboardFrame.height - self.suggestionListHeight
        var suggestionListY = minimumSuggestionListY
        
        if self.customView.categoryFieldView.textField.isFirstResponder {
            let lowerLeftCorner: CGPoint = {
                var corner = self.customView.categoryFieldView.frame.origin
                corner.y += self.customView.categoryFieldView.bounds.size.height
                corner = UIApplication.shared.keyWindow!.convert(corner, from: self.customView.categoryFieldView)
                return corner
            }()
            
            if lowerLeftCorner.y > minimumSuggestionListY {
                // The field appears below the suggestion list so take the deficit into account in the offset.
                contentOffsetY += lowerLeftCorner.y - suggestionListY
            } else {
                // Adjust the suggestion list.
                suggestionListY = lowerLeftCorner.y
            }
            
            self.suggestionList.fetchSuggestions(for: self.customView.categoryFieldView.textField.text, classifierType: .category)
            self.embedChildViewController(self.suggestionList, toView: self.view, fillSuperview: false)
            self.suggestionList.view.frame = {
                var frame = CGRect(x: 20,
                                   y: suggestionListY,
                                   width: self.view.bounds.size.width - 40,
                                   height: self.suggestionListHeight)
                frame = self.view.convert(frame, from: UIApplication.shared.keyWindow!)
                return frame
            }()
            self.suggestionList.view.setNeedsLayout()
            self.suggestionList.view.layoutIfNeeded()
            self.suggestionList.view.isHidden = true
        }
        
        // DEBUG
        else {
            self.suggestionList.unembedFromParentViewController()
        }
        
        let newInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height - self.tabBarController!.tabBar.bounds.size.height, 0)
        self.customView.scrollView.contentInset = newInsets
        self.customView.scrollView.scrollIndicatorInsets = newInsets
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {[unowned self] in
                self.customView.scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY)
            }, completion: {[unowned self] _ in
                self.suggestionList.view.isHidden = false
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        self.customView.scrollView.contentInset = .zero
        self.customView.scrollView.scrollIndicatorInsets = .zero
        
        self.suggestionList.unembedFromParentViewController()
        self.suggestionList.view.frame = .zero
    }
    
    @objc func handleTextFieldTextDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField
            else {
                return
        }
        
        let query = textField.text
        
        if textField == self.customView.categoryFieldView.textField {
            self.suggestionList.fetchSuggestions(for: query, classifierType: .category)
        }
    }
    
    @objc func handleTextFieldDidEndEditing(_ notification: Notification) {
        
    }
    
}

// MARK: - CategoryPickerViewControllerDelegate

extension ExpenseFormViewController: CategoryPickerViewControllerDelegate {
    
    func categoryPicker(_ picker: CategoryPickerViewController, didSelectCategory category: Category) {
        self.customView.categoryFieldView.textField.text = category.name
    }
    
}

// MARK: - UIScrollViewDelegate

extension ExpenseFormViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.suggestionList.unembedFromParentViewController()
    }
    
}

// MARK: - UITextFieldDelegate

extension ExpenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.customView.categoryFieldView.textField {
            CategoryPickerViewController.present(from: self)
        }
        return false
    }
    
}

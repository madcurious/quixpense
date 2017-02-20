//
//  EFCategoryPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class EFCategoryPickerVC: EFPickerVC {
    
    let searchVC = EFPickerSearchVC()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.title = "CATEGORY"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.embedChildViewController(self.searchVC, toView: self.customView.pickerViewContainer)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension EFCategoryPickerVC {
    
    func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       animations: {[unowned self] in
                        self.customView.contentViewBottom.constant = keyboardFrame.size.height
                        self.customView.contentViewHeight.constant = 44 * 5
                        self.customView.setNeedsLayout()
                        self.customView.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(notification: Notification) {
        guard let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       animations: {[unowned self] in
                        self.customView.contentViewBottom.constant = 0
                        self.customView.contentViewHeight.constant = self.customView.bounds.size.height / 2
                        self.customView.setNeedsLayout()
                        self.customView.layoutIfNeeded()
        })
    }
    
    override func handleTapOnDimView() {
        if self.searchVC.customView.textField.isFirstResponder {
            self.dismissKeyboard()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

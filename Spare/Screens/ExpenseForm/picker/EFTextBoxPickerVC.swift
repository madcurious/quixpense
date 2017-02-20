//
//  EFTextBoxPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class EFTextBoxPickerVC: EFPickerVC {
    
    let searchVC = EFTBPVCSearchVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(searchVC, toView: self.customView.mainViewContainer)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension EFTextBoxPickerVC {
    
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
    
}

//
//  CategoryPickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CategoryPickerVC: UIViewController {
    
    let customView = __CategoryPickerVCView.instantiateFromNib()
    
    let categories = App.allCategories()
    
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
        
        // Dismissal tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
        
        // Keyboard adjustments.
        let system = NotificationCenter.default
        system.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        system.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        system.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Target actions
extension CategoryPickerVC {
    
    func handleTapOnDimView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = keyboardFrame.height
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = 0
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        self.customView.tableViewBottom.constant = keyboardFrame.height
        self.customView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
}

extension CategoryPickerVC: UITableViewDataSource {
    
}

extension CategoryPickerVC: UITableViewDelegate {
    
}

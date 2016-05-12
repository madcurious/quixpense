//
//  __EEVCPickerTextField.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __EEVCPickerTextField: UITextField {
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // Disables the copy-paste functionality.
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: false)
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}


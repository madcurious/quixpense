//
//  __EEVCPickerTextField.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __EEVCPickerTextField: UITextField {
    
    override var text: String? {
        didSet {
            self.moveCursorToLeft()
        }
    }
    
    func moveCursorToLeft() {
        // Keeps the text display left-aligned to the beginning of the text.
        self.selectedTextRange = self.textRangeFromPosition(self.beginningOfDocument, toPosition: self.beginningOfDocument)
    }
    
    // Disable caret.
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
    
    // Disable magnifying glass.
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if let longPress = gestureRecognizer as? UILongPressGestureRecognizer {
            longPress.enabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        NSOperationQueue.mainQueue().addOperationWithBlock { 
//            UIMenuController.sharedMenuController().setMenuVisible(false, animated: false)
//        }
//        
//        switch action {
//        case #selector(copy(_:)), #selector(selectAll(_:)), #selector(select(_:)), #selector(paste(_:)):
//            return false
//            
//        default:
//            return super.canPerformAction(action, withSender: sender)
//        }
        return false
    }
    
}


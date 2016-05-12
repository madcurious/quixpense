//
//  FieldButton.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private class FieldButtonLabel: UILabel {
    
    private override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 10)))
    }
    
}

class FieldButton: UIControl {
    
    private static let highlightAlpha = CGFloat(0.7)
    
    private let textLabel = FieldButtonLabel()
    private let placeholder = NSAttributedString(
        string: Strings.FieldPlaceholder,
        attributes: [
            NSForegroundColorAttributeName : Color.FormPlaceholderTextColor,
            NSFontAttributeName : Font.FieldValue
        ])
    
    var value: Any?
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        
        self.textLabel.font = Font.FieldValue
        self.textLabel.textColor = Color.FormFieldValueTextColor
        self.addSubviewAndFill(self.textLabel)
        
        self.setValue(nil, displayText: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(value: Any?, displayText: String?) {
        self.value = value
        if let _ = value {
            self.textLabel.text = displayText
        } else {
            self.textLabel.attributedText = self.placeholder
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textLabel.alpha = FieldButton.highlightAlpha
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textLabel.alpha = 1.0
        
        if let touch = touches.first
            where CGRectContainsPoint(self.frame, touch.locationInView(self)) {
            self.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.textLabel.alpha = 1.0
    }
    
}
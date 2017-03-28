//
//  _EFVCNotesBox.swift
//  Spare
//
//  Created by Matt Quiros on 17/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCNotesBox: _EFVCFieldBox {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override var mainResponder: UIView {
        return self.textView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldLabel.text = "NOTES"
        
        self.textView.text = nil
        self.textView.font = Font.regular(17)
        self.textView.textContainerInset = UIEdgeInsetsMake(
            0,
            -self.textView.textContainer.lineFragmentPadding,
            0,
            -self.textView.textContainer.lineFragmentPadding)
        self.textView.backgroundColor = UIColor.clear
        
        self.placeholderLabel.text = "e.g. Ask for reimbursement!"
        self.placeholderLabel.font = self.textView.font
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: Notification.Name.UITextViewTextDidChange, object: self.textView)
    }
    
    override func applyTheme() {
        super.applyTheme()
        self.iconImageView.image = UIImage.templateNamed("notesIcon")
        self.placeholderLabel.textColor = Global.theme.color(for: .textFieldPlaceholder)
        self.textView.textColor = Global.theme.color(for: .textFieldValue)
    }
    
    func handleTextDidChange() {
        if let text = self.textView.text,
            text.characters.count > 0 {
            self.placeholderLabel.isHidden = true
        } else {
            self.placeholderLabel.isHidden = false
        }
    }
    
}

//
//  __EEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 03/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class __EEVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var separatorViews: [UIView]!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    
    @IBOutlet var fieldBoxes: [UIView]!
    @IBOutlet var fieldLabels: [UILabel]!
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: __EEVCPickerTextField!
    @IBOutlet weak var dateTextField: __EEVCPickerTextField!
    @IBOutlet weak var paymentMethodControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background colors.
        self.backgroundColor = Color.UniversalBackgroundColor
        UIView.clearBackgroundColors(
            self.scrollView,
            self.contentView
        )
        for separatorView in self.separatorViews {
            separatorView.backgroundColor = Color.SeparatorColor
        }
        for box in self.fieldBoxes {
            box.backgroundColor = UIColor.clearColor()
        }
        
        self.separatorViewHeight.constant = 0.5
        
        // Setup labels.
        let texts = ["AMOUNT", "CATEGORY", "DATE SPENT", "PAID WITH", "NOTES"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textColor = Color.FormFieldLabelTextColor
            label.font = Font.FieldLabel
            label.text = texts[i]
        }
        
        // Setup text fields.
        let textFields = [self.noteTextField, self.amountTextField, self.categoryTextField, self.dateTextField]
        for textField in textFields {
            textField.font = Font.FormValue
            textField.textColor = Color.UniversalTextColor
            textField.adjustsFontSizeToFitWidth = false
            textField.textAlignment = .Right
            textField.attributedPlaceholder = {
                if textField == self.noteTextField {
                    return NSAttributedString(string: Strings.FieldPlaceholderOptional, font: Font.FieldValue, textColor: Color.FormFieldPlaceholderColor)
                }
                return NSAttributedString(string: Strings.FieldPlaceholderRequired, font: Font.FieldValue, textColor: Color.FormFieldPlaceholderColor)
            }()
        }
        self.noteTextField.autocapitalizationType = .Sentences
        self.amountTextField.keyboardType = .DecimalPad
        
        // Setup segmented control.
        let paymentMethods = ["CASH", "CREDIT", "DEBIT"]
        for i in 0..<paymentMethods.count {
            let title = paymentMethods[i]
            self.paymentMethodControl.setTitle(title, forSegmentAtIndex: i)
        }
        self.paymentMethodControl.setTitleTextAttributes([NSFontAttributeName: Font.text(.Regular, 14)], forState: .Normal)
        self.paymentMethodControl.tintColor = Color.UniversalTextColor
    }
    
}

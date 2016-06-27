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
    @IBOutlet var fieldBoxes: [UIView]!
    @IBOutlet var fieldLabels: [UILabel]!
    
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: __EEVCPickerTextField!
    @IBOutlet weak var dateTextField: __EEVCPickerTextField!
    @IBOutlet weak var paymentMethodControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background colors.
        self.backgroundColor = Color.ScreenBackgroundColorLightGray
        UIView.clearBackgroundColors(
            self.scrollView,
            self.contentView
        )
        
        // Setup labels.
        let texts = ["DESCRIPTION", "AMOUNT", "CATEGORY", "DATE SPENT", "PAID WITH"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textColor = Color.FormFieldLabelTextColor
            label.font = Font.FieldLabel
            label.text = texts[i]
        }
        
        // Setup text fields.
        let textFields = [self.itemDescriptionTextField, self.amountTextField, self.categoryTextField, self.dateTextField]
        for textField in textFields {
            textField.font = Font.FieldValue
            textField.textColor = Color.Black
            textField.placeholder = Strings.FieldPlaceholder
            textField.adjustsFontSizeToFitWidth = false
        }
        self.itemDescriptionTextField.autocapitalizationType = .Sentences
        self.amountTextField.keyboardType = .DecimalPad
        
        // Setup segmented control.
        let paymentMethods = ["CASH", "CREDIT", "DEBIT"]
        for i in 0..<paymentMethods.count {
            let title = paymentMethods[i]
            self.paymentMethodControl.setTitle(title, forSegmentAtIndex: i)
        }
        self.paymentMethodControl.setTitleTextAttributes([NSFontAttributeName: Font.text(.Regular, 14)], forState: .Normal)
        self.paymentMethodControl.tintColor = Color.Black
    }
    
}

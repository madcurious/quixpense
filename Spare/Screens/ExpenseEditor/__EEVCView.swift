//
//  __EEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 13/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class __EEVCView: UIView {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var fieldContainer: UIView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var paymentMethodContainer: UIView!
    @IBOutlet weak var noteContainer: UIView!
    
    @IBOutlet var fieldLabels: [UILabel]!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var keypadCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.topContainer,
            self.fieldContainer,
            self.categoryContainer,
            self.dateContainer,
            self.paymentMethodContainer,
            self.noteContainer,
            self.amountTextField
        )
        self.backgroundColor = Color.UniversalBackgroundColor
        self.keypadCollectionView.backgroundColor = Color.KeypadBackgroundColor
        
        let labels = ["CATEGORY", "DATE SPENT", "PAID WITH", "NOTES"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textAlignment = .Right
            label.textColor = Color.FieldLabelTextColor
            label.font = Font.FieldLabel
            label.text = labels[i]
        }
        
        let buttons = [self.categoryButton, self.dateButton, self.paymentMethodButton]
        for button in buttons {
            button.tintColor = Color.FieldValueTextColor
            button.titleLabel?.font = Font.FieldValue
            button.contentHorizontalAlignment = .Left
        }
        
        self.noteTextField.font = Font.FieldValue
        self.noteTextField.textColor = Color.FieldValueTextColor
        self.noteTextField.attributedPlaceholder = NSAttributedString(string: "(Optional)", font: Font.FieldValue, textColor: Color.FieldPlaceholderTextColor)
        
        self.currencyLabel.textColor = Color.FieldLabelTextColor
        self.currencyLabel.text = "PHP"
        self.currencyLabel.font = Font.ExpenseEditorCurrencyLabel
        
        self.amountTextField.userInteractionEnabled = false
        self.amountTextField.textColor = Color.FieldValueTextColor
        self.amountTextField.font = Font.ExpenseEditorAmountValue
        self.amountTextField.textAlignment = .Right
        self.amountTextField.attributedPlaceholder = NSAttributedString(string: "0", font: Font.ExpenseEditorAmountValue, textColor: Color.FieldValueTextColor)
    }
    
}

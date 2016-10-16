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
    @IBOutlet weak var amountContainer: UIView!
    
    @IBOutlet var fieldLabels: [UILabel]!
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var currencyLabel: MDResponsiveLabel!
    @IBOutlet weak var amountTextField: MDResponsiveTextField!
    
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
            self.amountContainer,
            self.amountTextField
        )
        self.backgroundColor = Color.UniversalBackgroundColor
        self.keypadCollectionView.backgroundColor = Color.KeypadBackgroundColor
        
        let labels = ["CATEGORY", "DATE SPENT", "PAID WITH", "NOTES"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textAlignment = .right
            label.textColor = Color.FieldLabelTextColor
            label.font = {
                if MDScreen.currentScreenIs(.iPhone4S) {
                    return Font.FieldLabel.withSize(12)
                }
                return Font.FieldLabel
            }()
            label.text = labels[i]
        }
        
        let textFields = [self.categoryTextField, self.noteTextField] as [UITextField]
        let placeholders = ["Type and select...", "(Optional)"]
        for i in 0 ..< textFields.count {
            let textField = textFields[i]
            textField.font = Font.FieldValue
            textField.textColor = Color.FieldValueTextColor
            textField.attributedPlaceholder = NSAttributedString(string: placeholders[i], font: Font.FieldValue, textColor: Color.FieldPlaceholderTextColor)
            textField.adjustsFontSizeToFitWidth = false
        }
        
        
        let buttons = [self.dateButton, self.paymentMethodButton]
        for button in buttons {
            button?.tintColor = Color.FieldValueTextColor
            button?.titleLabel?.font = {
                if MDScreen.currentScreenIs(.iPhone4S) {
                    return Font.FieldValue.withSize(17)
                }
                return Font.FieldValue
            }()
            button?.contentHorizontalAlignment = .left
            button?.titleLabel?.numberOfLines = 1
            button?.titleLabel?.lineBreakMode = .byTruncatingTail
        }
        
        self.currencyLabel.textColor = Color.FieldLabelTextColor
        self.currencyLabel.text = AmountFormatter.currencyCode()
        self.currencyLabel.font = Font.ExpenseEditorCurrencyLabel
        self.currencyLabel.fontSize = .vHeight(0.8)
        
        self.amountTextField.isUserInteractionEnabled = false
        self.amountTextField.textColor = Color.FieldValueTextColor
        self.amountTextField.attributedPlaceholder = NSAttributedString(string: "0", font: Font.ExpenseEditorAmountValue, textColor: Color.FieldValueTextColor)
        self.amountTextField.font = Font.ExpenseEditorAmountValue
        self.amountTextField.fontSize = .vHeight(0.8)
        self.amountTextField.textAlignment = .right
        
        self.keypadCollectionView.isScrollEnabled = false
        self.keypadCollectionView.allowsSelection = true
        
        self.setNeedsUpdateConstraints()
    }
    
}

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
    @IBOutlet private weak var amountLabel: UILabel!
    
    @IBOutlet weak var keypadCollectionView: UICollectionView!
    
    var amountText: String? {
        didSet {
            defer {
                self.setNeedsLayout()
                
                if let amountText = self.amountText {
                    self.amountLabel.text = amountText
                } else {
                    self.amountLabel.text = "0"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.topContainer,
            self.fieldContainer,
            self.categoryContainer,
            self.dateContainer,
            self.paymentMethodContainer,
            self.noteContainer,
            self.amountContainer
        )
        
        self.backgroundColor = Color.UniversalBackgroundColor
        self.keypadCollectionView.backgroundColor = Color.KeypadBackgroundColor
        
        let labels = ["CATEGORY", "DATE SPENT", "PAID WITH", "NOTES"]
        for i in 0..<self.fieldLabels.count {
            let label = self.fieldLabels[i]
            label.textAlignment = .right
            label.textColor = Color.FieldLabelTextColor
            label.font = {
                if MDScreen.currentScreenIs(.iPhone4) {
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
                if MDScreen.currentScreenIs(.iPhone4) {
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
        
        let amountTextFieldFont: UIFont = {
            switch MDScreen.currentScreen() {
            case .iPhone4, .iPhone5:
                return Font.make(.Heavy, 20)
            case .iPhone6, .iPhone6p:
                return Font.make(.Heavy, 30)
            }
        }()
        
        self.amountLabel.textColor = Color.FieldValueTextColor
        self.amountLabel.font = amountTextFieldFont
        self.amountLabel.adjustsFontSizeToFitWidth = true
        self.amountLabel.textAlignment = .right
        self.amountLabel.numberOfLines = 1
        self.amountLabel.lineBreakMode = .byClipping
        
        self.keypadCollectionView.isScrollEnabled = false
        self.keypadCollectionView.allowsSelection = true
        
        self.setNeedsUpdateConstraints()
    }
    
}

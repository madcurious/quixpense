//
//  _EFVCAmountBox.swift
//  Spare
//
//  Created by Matt Quiros on 15/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class _EFVCAmountBox: _EFVCFieldBox {
    
    @IBOutlet weak var textField: UITextField!
    
    override var mainResponder: UIView {
        return self.textField
    }
    
    let currencyLabel = UILabel(frame: CGRect.zero)
    let numberFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImageView.image = UIImage.templateNamed("amountIcon")
        
        self.fieldLabel.text = "AMOUNT"
        
        self.textField.backgroundColor = UIColor.clear
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.placeholder = "0.00"
        
        self.currencyLabel.font = Global.theme.font(for: .regularText)
        self.currencyLabel.text = AmountFormatter.currencySymbol()
        self.currencyLabel.frame = CGRect(x: 0, y: 0, width: 20, height: self.currencyLabel.intrinsicContentSize.height)
        self.textField.leftView = self.currencyLabel
        self.textField.leftViewMode = .always
        
        self.textField.keyboardType = .decimalPad
        self.textField.delegate = self
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        self.currencyLabel.textColor = Global.theme.color(for: .fieldName)
    }
    
}

extension _EFVCAmountBox: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let fullText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
            fullText.characters.count > 0,
            self.numberFormatter.number(from: fullText) == nil {
            return false
        }
        return true
    }
    
}

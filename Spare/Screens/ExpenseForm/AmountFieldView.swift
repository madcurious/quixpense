//
//  AmountFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class AmountFieldView: UIView, Themeable {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.textField.keyboardType = .decimalPad
        self.textField.delegate = self
    }
    
    func applyTheme() {
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.textColor = Global.theme.color(for: .regularText)
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
    }
    
}

extension AmountFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Don't allow text editing if the text replacement contains invalid characters.
        if let _ = string.rangeOfCharacter(from: self.invalidCharacterSet) {
            return false
        }
        return true
    }
    
}

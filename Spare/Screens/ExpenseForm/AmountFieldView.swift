//
//  AmountFieldView.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class AmountFieldView: UIView, Themeable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    let currencyLabel = UILabel()
    let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
        
        self.imageView.image = UIImage.templateNamed("amountIcon")
        
        self.currencyLabel.text = AmountFormatter.currencySymbol()
        self.currencyLabel.textAlignment = .left
        
        self.textField.keyboardType = .decimalPad
        self.textField.leftView = self.currencyLabel
        self.textField.leftViewMode = .always
        self.textField.delegate = self
    }
    
    func applyTheme() {
        self.imageView.tintColor = Global.theme.color(for: .fieldIcon)
        
        self.currencyLabel.textColor = Global.theme.color(for: .placeholder)
        self.currencyLabel.font = Global.theme.font(for: .regularText)
        
        self.textField.font = Global.theme.font(for: .regularText)
        self.textField.textColor = Global.theme.color(for: .regularText)
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.currencyLabel.frame = CGRect(x: 0, y: 0, width: 20, height: self.currencyLabel.intrinsicContentSize.height)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.frame.contains(point) {
            return self.textField
        }
        return super.hitTest(point, with: event)
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

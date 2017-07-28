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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyTheme()
        
        imageView.image = UIImage.templateNamed("amountIcon")
        
        currencyLabel.text = AmountFormatter.currencySymbol()
        currencyLabel.textAlignment = .left
        
        textField.keyboardType = .decimalPad
        textField.leftView = currencyLabel
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
    }
    
    func applyTheme() {
        imageView.tintColor = Global.theme.color(for: .fieldIcon)
        
        currencyLabel.textColor = Global.theme.color(for: .placeholder)
        currencyLabel.font = Global.theme.font(for: .regularText)
        
        textField.font = Global.theme.font(for: .regularText)
        textField.textColor = Global.theme.color(for: .regularText)
        textField.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            font: Global.theme.font(for: .regularText),
            textColor: Global.theme.color(for: .placeholder))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currencyLabel.frame = CGRect(x: 0, y: 0, width: 20, height: currencyLabel.intrinsicContentSize.height)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if textField.frame.contains(point) == false &&
            frame.contains(point) {
            return textField
        }
        return super.hitTest(point, with: event)
    }
    
}


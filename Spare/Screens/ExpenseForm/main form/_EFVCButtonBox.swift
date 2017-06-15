//
//  _EFVCButtonBox.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class _EFVCButtonBox: _EFVCFieldBox {
    
    @IBOutlet weak var fieldButton: MDTextFieldButton!
    
    override var mainResponder: UIView {
        return self.fieldButton
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldButton.backgroundColor = UIColor.clear
        self.fieldButton.font = Global.theme.font(for: .regularText)
        
        self.applyTheme()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        self.fieldLabel.textColor = Global.theme.color(for: .fieldName)
        
        self.fieldButton.placeholderTextColor = Global.theme.color(for: .textFieldPlaceholder)
        self.fieldButton.textColor = Global.theme.color(for: .textFieldValue)
    }
    
}

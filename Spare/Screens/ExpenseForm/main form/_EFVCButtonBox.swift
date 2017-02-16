//
//  _EFVCButtonBox.swift
//  Spare
//
//  Created by Matt Quiros on 16/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class _EFVCButtonBox: _EFVCFieldBox, Themeable {
    
    @IBOutlet weak var fieldButton: MDTextFieldButton!
    
    override var mainResponder: UIView {
        return self.fieldButton
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldButton.font = Font.regular(17)
        
        self.applyTheme()
    }
    
    func applyTheme() {
        self.fieldLabel.textColor = Global.theme.formFieldNameTextColor
        
        self.fieldButton.placeholderTextColor = Global.theme.formFieldPlaceholderTextColor
        self.fieldButton.textColor = Global.theme.formFieldValueTextColor
    }
    
}

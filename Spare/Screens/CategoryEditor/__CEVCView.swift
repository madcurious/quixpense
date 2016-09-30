//
//  __CEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
//import Color_Picker_for_iOS
import NKOColorPickerView

class __CEVCView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameFieldContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var colorFieldContainer: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorBoxView: UIView!
    
    @IBOutlet weak var colorPickerControl: ColorPickerControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.clearBackgroundColors(
            self.scrollView,
            self.contentView,
            self.nameFieldContainer,
            self.colorFieldContainer,
            self.colorPickerControl
            )
        self.backgroundColor = Color.UniversalBackgroundColor
        
        self.nameLabel.text = "NAME"
        self.nameLabel.font = Font.FieldLabel
        self.nameLabel.textColor = Color.FieldLabelTextColor
        self.nameLabel.textAlignment = .Right
        
        self.nameTextField.textColor = Color.UniversalTextColor
        self.nameTextField.font = Font.FieldValue
        self.nameTextField.autocapitalizationType = .Sentences
        self.nameTextField.adjustsFontSizeToFitWidth = false
        
        self.colorLabel.text = "COLOR"
        self.colorLabel.font = Font.FieldLabel
        self.colorLabel.textColor = Color.FieldLabelTextColor
        self.colorLabel.textAlignment = .Right
        
        self.colorTextField.userInteractionEnabled = false
        self.colorTextField.textColor = Color.UniversalTextColor
        self.colorTextField.font = Font.FieldValue
        self.colorTextField.adjustsFontSizeToFitWidth = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorBoxView.layer.cornerRadius = 2.0
    }
    
}

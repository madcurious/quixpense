//
//  ColorPickerControl.swift
//  Spare
//
//  Created by Matt Quiros on 30/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import NKOColorPickerView

class ColorPickerControl: UIControl {
    
    let colorPicker = NKOColorPickerView(frame: CGRectZero)
    
    var selectedColor: UIColor {
        get {
            return self.colorPicker.color
        }
        set {
            self.colorPicker.color = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.addSubviewAndFill(self.colorPicker)
        
        // Set a default color.
        self.colorPicker.color = UIColor.redColor()
        
        self.colorPicker.didChangeColorBlock = {[unowned self] _ in
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
}
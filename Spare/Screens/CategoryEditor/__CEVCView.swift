//
//  __CEVCView.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS

class __CEVCView: UIView {
    
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var textField: __CEVCTextField!
    
    @IBOutlet weak var colorMapExtendedArea: __CEVCColorMapTouchArea!
    @IBOutlet weak var colorMapBorderView: __CEVCColorMapTouchArea!
    @IBOutlet weak var colorMapContainer: __CEVCColorMapTouchArea!
    
    @IBOutlet weak var sliderContainer: __CEVCSliderTouchArea!
    
    @IBOutlet weak var sliderTrackContainer: UIView!
    
    weak var colorMap: HRColorMapView? {
        willSet {
            if let colorMap = self.colorMap {
                colorMap.removeFromSuperview()
            }
        }
        
        didSet {
            if let colorMap = self.colorMap {
                self.colorMapContainer.addSubviewAndFill(colorMap)
            }
        }
    }
    
    weak var slider: HRBrightnessSlider? {
        willSet {
            if let slider = self.slider {
                slider.removeFromSuperview()
            }
        }
        
        didSet {
            if let slider = self.slider {
                self.sliderTrackContainer.addSubviewAndFill(slider)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.FormBackgroundColor
        self.textFieldContainer.backgroundColor = Color.White
        self.colorMapExtendedArea.backgroundColor = UIColor.clearColor()
        self.colorMapBorderView.backgroundColor = Color.White
        self.colorMapContainer.backgroundColor = UIColor.clearColor()
        self.sliderContainer.backgroundColor = UIColor.clearColor()
        self.sliderTrackContainer.backgroundColor = UIColor.clearColor()
        
        self.fieldLabel.text = "NAME"
        self.fieldLabel.textColor = Color.FormFieldLabelTextColor
        self.fieldLabel.font = Font.FieldLabel
        
        // Add parent references for touch passing.
        self.colorMapExtendedArea.parent = self
        self.colorMapContainer.parent = self
        self.sliderContainer.parent = self
    }
    
}

class __CEVCTextField: UITextField {
    
    let inset = CGFloat(8)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.borderStyle = .None
        
        self.font = Font.text(.Bold, 18)
        self.autocapitalizationType = .Sentences
        self.clearButtonMode = .WhileEditing
        self.placeholder = Strings.FieldPlaceholder
        self.textColor = Color.White
        self.adjustsFontSizeToFitWidth = false
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.inset, self.inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.inset, self.inset)
    }
    
}

class __CEVCColorMapTouchArea: UIView {
    
    weak var parent: __CEVCView?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView == self {
            return self.parent?.colorMap
        }
        return hitView
    }
    
}

class __CEVCSliderTouchArea: UIView {
    
    weak var parent: __CEVCView?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView == self {
            return self.parent?.slider
        }
        return hitView
    }
    
}
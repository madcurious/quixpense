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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameFieldContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var colorFieldContainer: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorBoxView: UIView!
    
    @IBOutlet weak var colorMapContainer: UIView!
    @IBOutlet weak var colorMapExtendedTouchArea: __CEVCColorMapTouchArea!
    
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
        
        UIView.clearBackgroundColors(
            self.scrollView,
            self.contentView,
            self.nameFieldContainer,
            self.colorFieldContainer,
            self.colorMapExtendedTouchArea,
            self.colorMapContainer,
            self.sliderContainer,
            self.sliderTrackContainer)
        self.backgroundColor = Color.UniversalBackgroundColor
//        self.textFieldContainer.backgroundColor = Color.White
//        self.colorMapBorderView.backgroundColor = Color.White
        
//        self.fieldLabel.text = "NAME"
//        self.fieldLabel.textColor = Color.FieldLabelTextColor
//        self.fieldLabel.font = Font.FieldLabel
        
        self.nameLabel.text = "NAME"
        self.nameLabel.font = Font.FieldLabel
        self.nameLabel.textColor = Color.FieldLabelTextColor
        self.nameLabel.textAlignment = .Right
        
        self.colorLabel.text = "COLOR"
        self.colorLabel.font = Font.FieldLabel
        self.colorLabel.textColor = Color.FieldLabelTextColor
        self.colorLabel.textAlignment = .Right
        
        // Add parent references for touch passing.
        self.colorMapExtendedTouchArea.parent = self
        self.sliderContainer.parent = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorBoxView.layer.cornerRadius = 2.0
    }
    
}

class __CEVCTextField: UITextField {
    
    let inset = CGFloat(8)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.borderStyle = .None
        
        self.font = Font.make(.Heavy, 18)
        self.autocapitalizationType = .Sentences
        self.clearButtonMode = .WhileEditing
        self.placeholder = Strings.FieldPlaceholderRequired
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
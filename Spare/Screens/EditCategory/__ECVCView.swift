//
//  __ECVCView.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS

class __ECVCView: UIView {
    
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var textField: __ECVCTextField!
    @IBOutlet weak var colorMapContainer: UIView!
    @IBOutlet weak var sliderContainer: __ECVCViewSliderContainer!
    
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
            if let slider = self.sliderContainer.slider {
                slider.removeFromSuperview()
            }
        }
        
        didSet {
            self.sliderContainer.slider = self.slider
            if let slider = self.slider {
                self.sliderTrackContainer.addSubviewAndFill(slider)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.Gray1
        self.textFieldContainer.backgroundColor = Color.White
        self.colorMapContainer.backgroundColor = UIColor.clearColor()
        self.sliderContainer.backgroundColor = UIColor.clearColor()
        self.sliderTrackContainer.backgroundColor = UIColor.clearColor()
        
        self.fieldLabel.text = "NAME"
        self.fieldLabel.textColor = Color.Gray10
        self.fieldLabel.font = Font.get(.Bold, size: 14)
    }
    
}

class __ECVCTextField: UITextField {
    
    let inset = CGFloat(8)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.borderStyle = .None
        
        self.font = Font.get(.Regular, size: 18)
        self.autocapitalizationType = .Sentences
        self.clearButtonMode = .WhileEditing
        self.placeholder = "Type here"
        self.textColor = Color.White
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.inset, self.inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, self.inset, self.inset)
    }
    
}

class __ECVCViewSliderContainer: UIView {
    
    weak var slider: HRBrightnessSlider?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView == self {
            return self.slider
        }
        return hitView
    }
    
}
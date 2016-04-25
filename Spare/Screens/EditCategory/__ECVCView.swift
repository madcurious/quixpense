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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colorMapContainer: UIView!
    @IBOutlet weak var sliderContainer: __ECVCViewSliderContainer!
    
    @IBOutlet weak var sliderTrackContainer: UIView!
    
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
        
        self.colorMapContainer.backgroundColor = UIColor.clearColor()
        self.sliderContainer.backgroundColor = UIColor.clearColor()
        self.sliderTrackContainer.backgroundColor = UIColor.clearColor()
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
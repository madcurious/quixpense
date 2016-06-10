//
//  CategoryEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Color_Picker_for_iOS
import Mold

class CategoryEditorVC: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var category: Category
    
    let customView = __CEVCView.instantiateFromNib() as __CEVCView
    let colorMap: HRColorMapView
    let slider: HRBrightnessSlider
    
    private let defaultColor = UIColor.redColor()
    
    init(category: Category?) {
        let context = App.state.coreDataStack.newBackgroundWorkerMOC()
        self.managedObjectContext = context
        
        if let category = category,
            let colorHex = category.colorHex as? Int {
            self.category = category
            self.colorMap = HRColorMapView.defaultColorMap(UIColor(hex: colorHex))
        } else {
            self.category = Category(managedObjectContext: context)
            self.category.colorHex = self.defaultColor.hexValue()
            self.colorMap = HRColorMapView.defaultColorMap(self.defaultColor)
        }
        
        self.slider = HRBrightnessSlider()
        
        super.init(nibName: nil, bundle: nil)
        
        self.slider.brightnessLowerLimit = 0.3
        self.slider.color = self.defaultColor
        
        self.customView.colorMap = self.colorMap
        self.customView.slider = self.slider
        
        self.customView.textField.backgroundColor = self.getResultingColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGlobalVCSettings(self)
        
        self.colorMap.addTarget(self, action: #selector(handleTapOnColorMap(_:)), forControlEvents: .ValueChanged)
        self.slider.addTarget(self, action: #selector(handleBrightnessValueChange(_:)), forControlEvents: .ValueChanged)
        
        self.customView.textField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
    }
    
    func handleTapOnView() {
        self.dismissKeyboard()
    }
    
    func handleTapOnColorMap(sender: AnyObject) {
        self.dismissKeyboard()
        
        // When the color map is tapped, a color has been selected and the cursor
        // should be displayed.
        self.colorMap.cursor.hidden = false
        
        // Reset the brightness to 100%.
        self.slider.color = self.colorMap.color
        
        self.customView.textField.backgroundColor = self.getResultingColor()
        self.category.colorHex = self.getResultingColor().hexValue()
    }
    
    func handleBrightnessValueChange(sender: AnyObject) {
        self.customView.textField.backgroundColor = self.getResultingColor()
        self.category.colorHex = self.getResultingColor().hexValue()
    }
    
    func getResultingColor() -> UIColor {
        var color = HRHSVColor()
        HSVColorFromUIColor(self.colorMap.color, &color)
        let brightness = self.slider.brightness as CGFloat
        
        return UIColor(hue: color.h, saturation: color.s, brightness: brightness, alpha: 1)
    }
    
    /**
     Clears the form and creates a new `Category` object with form-initial values.
     */
    func reset() {
        self.customView.textField.text = nil
        self.category = Category(managedObjectContext: self.managedObjectContext)
        self.category.name = nil
        self.category.colorHex = self.getResultingColor().hexValue()
    }
    
}

extension CategoryEditorVC: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let name = NSString(string: textField.text ?? "").stringByReplacingCharactersInRange(range, withString: string)
        self.category.name = name
        return true
    }
    
}


//
//  HRColorMapView.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS

extension HRColorMapView {
    
    var cursor: HRColorCursor {
        for subview in self.subviews {
            if let cursor = subview as? HRColorCursor {
                return cursor
            }
        }
        fatalError("Did not find a cursor subview.")
    }
    
    class func defaultColorMap(selectedColor: UIColor?) -> HRColorMapView {
        let colorMap = HRColorMapView.colorMapWithFrame(CGRectZero, saturationUpperLimit: 1)
        colorMap.tileSize = 1
        colorMap.brightness = 1
        colorMap.saturationUpperLimit = 0.7
        
        if let color = selectedColor {
            colorMap.color = color
        } else {
            colorMap.cursor.hidden = true
        }
        
        return colorMap
    }
    
}
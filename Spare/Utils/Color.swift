//
//  Color.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class Color {
    
    static let White = UIColor.whiteColor()
    static let Black = UIColor.blackColor()
    
    // Numbers indicate brightness; smaller = brighter.
    
    private static let Gray100 = UIColor(hex: 0xf0f2f6)
    private static let Gray150 = UIColor(hex: 0xf6f6f6)
    
    /// Form placeholder text color.
    private static let Gray170 = UIColor(hex: 0xc7c7cd)
    
    /// Tab bar button selected background color.
    private static let Gray200 = UIColor(hex: 0xcdcdcd)
    
    /// Form field label text color.
    private static let Gray700 = UIColor(hex: 0x666666)
    
    /// Modal navigation bar background color.
    private static let Gray900 = UIColor(hex: 0x2a2a2a)
    
    static let FormBackgroundColor = Gray100
    static let FormFieldLabelTextColor = Gray700
    static let FormFieldValueTextColor = Black
    static let FormPlaceholderTextColor = Gray200
    
    static let ModalNavigationBarBackgroundColor = Gray900
    
    static let ScreenBackgroundColorLightGray = Gray100
    
    static let TabButtonHighlightBackgroundColor = Gray150
    static let TabButtonIconColor = Gray700
    static let TabButtonSelectedBackgroundColor = Gray200
    
    
}
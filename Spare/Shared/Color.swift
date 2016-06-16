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
    
    // MARK: - Palette
    
    static let White = UIColor.whiteColor()
    static let Black = UIColor.blackColor()
    
    // Numbers indicate brightness; smaller = brighter.
    
    private static let Gray50 = UIColor(hex: 0xf6f6f6)
    private static let Gray100 = UIColor(hex: 0xf0f2f6)
    private static let Gray200 = UIColor(hex: 0xe6e6e6)
    private static let Gray400 = UIColor(hex: 0xcdcdcd)
    private static let Gray700 = UIColor(hex: 0x666666)
    
    // MARK: - UI Colors
    
    static let HomeCellBorderColor = Gray400
    
    static let FormFieldLabelTextColor = Gray700
    static let FormFieldValueTextColor = Black
    static let FormPlaceholderTextColor = Gray400
    
    static let ModalNavigationBarBackgroundColor = White
    static let ModalNavigationBarTintColor = Gray700
    
    static let ScreenBackgroundColorLightGray = Gray100
    
    static let SummarySegmentedCircleEmptyColor = Gray200
    static let SummaryFooterViewTextColor = Gray700
    
    static let TabButtonHighlightBackgroundColor = Gray50
    static let TabButtonIconColor = Gray700
    static let TabButtonSelectedBackgroundColor = Gray400
    
    
}
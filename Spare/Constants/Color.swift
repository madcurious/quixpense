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
    
    static let Black = UIColor.blackColor()
    static let Hex111111 = UIColor(hex: 0x111111)
    static let Hex222222 = UIColor(hex: 0x222222)
    static let Hex282828 = UIColor(hex: 0x282828)
    static let Hex333333 = UIColor(hex: 0x333333)
    static let Hex4e4e4e = UIColor(hex: 0x4e4e4e)
    static let Hex666666 = UIColor(hex: 0x666666)
    static let Hexaaaaaa = UIColor(hex: 0xaaaaaa)
    static let White = UIColor.whiteColor()
    
    // MARK: - New colors
    
    static let CustomPickerHeaderTextColor = Hexaaaaaa
    static let CustomPickerItemTextColor = Hex111111
    
    static let FieldLabelTextColor = Hex666666
    static let FieldValueTextColor = White
    static let FieldPlaceholderTextColor = Hex333333
    
    static let KeypadBackgroundColor = Hex222222
    static let KeypadHighlightedBackgroundColor = Hex333333
    
    static let BarBackgroundColor = Hex222222
    
    static let SeparatorColor = Hex282828
    
    static let TabButtonSelectedBackgroundColor = Hex333333
    
    static let UniversalTextColor = White
    static let UniversalSecondaryTextColor = Gray700
    static let UniversalBackgroundColor = Hex111111
    
    // MARK: - Old UI Colors
    
    static let SegmentedCircleEmptyColor = Gray800
    
    private static let Gray50 = UIColor(hex: 0xf5f5f5)
    private static let Gray100 = UIColor(hex: 0xf0f2f6)
    private static let Gray200 = UIColor(hex: 0xe6e6e6)
    private static let Gray300 = UIColor(hex: 0xe0e0e0)
    private static let Gray400 = UIColor(hex: 0xcdcdcd)
    private static let Gray420 = UIColor(hex: 0xc6c6c6)
    private static let Gray500 = UIColor(hex: 0x898989)
    private static let Gray700 = UIColor(hex: 0x666666)
    private static let Gray800 = UIColor(hex: 0x444444)
    private static let Gray900 = UIColor(hex: 0x191919)
    
    static let CustomButtonDisabled = Black
    
    static let HomeCellBorderColor = Gray420
    
    
}
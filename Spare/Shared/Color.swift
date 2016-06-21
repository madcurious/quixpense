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
    private static let Gray300 = UIColor(hex: 0xdddddd)
    private static let Gray400 = UIColor(hex: 0xcdcdcd)
    private static let Gray420 = UIColor(hex: 0xc6c6c6)
    private static let Gray500 = UIColor(hex: 0x898989)
    private static let Gray700 = UIColor(hex: 0x666666)
    private static let Gray800 = UIColor(hex: 0x444444)
    private static let Gray900 = UIColor(hex: 0x222222)
    
    // MARK: - UI Colors
    
    static let FormFieldLabelTextColor = Gray700
    static let FormFieldValueTextColor = Black
    static let FormPlaceholderTextColor = Gray400
    
    static let HomeCellBorderColor = Gray420
    static let HomeScreenBackgroundColor = Gray300
    
    static let ModalNavigationBarBackgroundColor = White
    static let ModalNavigationBarTintColor = Gray700
    
    static let ScreenBackgroundColorLightGray = Gray100
    
    static let SummaryGraphTotalTextColor = Black
    static let SummaryGraphDateTextColor = Gray500
    static let SummaryCellBackgroundColor = Gray50
    static let SummaryCellTextColor = Gray700
    static let SummaryCellTextColorLight = White
    static let SummarySegmentedCircleEmptyColor = Gray200
    static let SummaryFooterViewTextColor = Gray700
    
    static let TabBarBackgroundColor = Gray900
    static let TabButtonHighlightBackgroundColor = Gray50
    static let TabButtonIconColor = White
    static let TabButtonSelectedBackgroundColor = Gray800
    
    
}
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
    
    // Numbers indicate brightness; smaller = brighter.
    
    static let White = UIColor.whiteColor()
    
    static let Black = UIColor.blackColor()
    
    static let Gray100 = UIColor(hex: 0xf0f2f6)         // form bg
    static let Gray150 = UIColor(hex: 0xf6f6f6)         // tab bar button highlight bg
    static let Gray200 = UIColor(hex: 0xcdcdcd)         // tab bar icon highlights
    static let Gray700 = UIColor(hex: 0x666666)         // form field labels
    static let Gray900 = UIColor(hex: 0x2a2a2a)         // nav bar bg
}
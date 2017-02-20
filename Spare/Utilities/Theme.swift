//
//  Theme.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

protocol Themeable {
    func applyTheme()
}

enum Theme {
    
    case light, dark
    
    var barBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.hex(0x2f2f2f)
        }
    }
    
    var barTintColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var fieldIconColor: UIColor {
        return self.fieldNameTextColor
    }
    
    var fieldNameTextColor: UIColor {
        switch self {
        case .light:
            return UIColor.hex(0xbbbbbb)
        case .dark:
            return UIColor.hex(0x999999)
        }
    }
    
    var fieldPlaceholderTextColor: UIColor {
        switch self {
        case .light:
            return UIColor.hex(0xdddddd)
        case .dark:
            return UIColor.hex(0x555555)
        }
    }
    
    var fieldValueTextColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var mainBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.hex(0x262626)
        }
    }
    
    /// For the text fields in pickers in the expense form.
    var pickerFieldValueTextColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
            
        case .dark:
            return UIColor.black
        }
    }
    
    var pickerTextFieldBackgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor.hex(0x666666)
            
        case .dark:
            return UIColor.white
        }
    }
    
    var tableViewSeparatorColor: UIColor {
        switch self {
        case .light:
            return UIColor.hex(0xdddddd)
            
        case .dark:
            return UIColor.hex(0x555555)
        }
    }
    
}

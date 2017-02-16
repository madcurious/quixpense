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
        if self == .light {
            return UIColor.white
        }
        return UIColor.hex(0x2f2f2f)
    }
    
    var barTintColor: UIColor {
        if self == .light {
            return UIColor.black
        }
        return UIColor.white
    }
    
    var formFieldNameTextColor: UIColor {
        if self == .light {
            return UIColor.hex(0xbbbbbb)
        }
        return UIColor.hex(0x999999)
    }
    
    var formFieldPlaceholderTextColor: UIColor {
        if self == .light {
            return UIColor.hex(0xdddddd)
        }
        return UIColor.hex(0x555555)
    }
    
    var formFieldValueTextColor: UIColor {
        if self == .light {
            return UIColor.black
        }
        return UIColor.white
    }
    
    var tableViewSeparatorColor: UIColor {
        if self == .light {
            return UIColor.hex(0xdddddd)
        }
        return UIColor.hex(0x555555)
    }
    
}

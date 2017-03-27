//
//  LightTheme.swift
//  Spare
//
//  Created by Matt Quiros on 09/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    
    func color(for element: UIElement) -> UIColor {
        switch element {
        case .barBackground,
             .elvcSectionHeaderText,
             .mainBackground,
             .pickerFieldValue:
            return UIColor.white
            
        case .barTint,
             .commonCellMainText,
             .cellAccessoryIcon,
             .fieldValue:
            return UIColor.black
            
        case .disclosureIndicator,
             .fieldPlaceholder,
             .tableViewSeparator:
            return UIColor.hex(0xdddddd)
            
        case .elvcCellDetailText:
            return UIColor.hex(0x999999)
            
        case .elvcSectionHeaderBackground,
             .pickerTextFieldBackground:
            return UIColor.hex(0x666666)
            
        case .fieldIcon,
             .fieldName:
            return UIColor.hex(0xbbbbbb)
            
        case .promptLabel:
            return UIColor.hex(0xaaaaaa)
        }
    }
    
}

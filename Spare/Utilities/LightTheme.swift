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
             .cellMainText,
             .cellAccessoryIcon,
             .textFieldValue:
            return UIColor.black
            
        case .cellAccessoryDisclosureIndicator,
             .tableViewSeparator,
             .textFieldPlaceholder:
            return UIColor.hex(0xdddddd)
            
        case .cellSecondaryText,
             .groupedTableViewSectionHeaderText:
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
    
    func font(for element: StringElement) -> UIFont {
        switch element {
        case .cellSecondaryText,
             .tableViewHeader:
            return UIFont(name: "NotoSansUI", size: 14)!
            
        case .navBarTitle:
            return UIFont(name: "NotoSansUI-Bold", size: 17)!
        case .regularText:
            return UIFont(name: "NotoSansUI", size: 17)!
        }
    }
    
}

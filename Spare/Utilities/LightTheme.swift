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
             .filterButtonContent,
             .mainBackground,
             .pickerFieldValue:
            return UIColor.white
            
        case .barTint,
             .cellMainText,
             .cellAccessoryIcon,
             .controlTint,
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
             .filterButtonBackground,
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
             .filterButtonText,
             .optionLabel,
             .tableViewHeader:
            return NotoSansUI.regular(14)
            
        case .infoLabelMainText:
            return NotoSansUI.regular(24)
            
        case .infoLabelSecondaryText:
            return NotoSansUI.regular(15)
            
        case .navBarTitle:
            return NotoSansUI.bold(17)
            
        case .regularText:
            return NotoSansUI.regular(17)
        }
    }
    
}

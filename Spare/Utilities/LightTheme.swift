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
             .sectionTotalHeaderViewText,
             .filterButtonContent,
             .mainBackground:
            return UIColor.white
            
        case .barTint,
             .controlTint,
             .regularText:
            return UIColor.black
            
        case .disclosureIndicator,
             .placeholder,
             .tableViewSeparator:
            return UIColor.hex(0xdddddd)
            
        case .fieldIcon,
             .groupedTabledViewSectionHeader,
             .promptLabel:
            return UIColor.hex(0x999999)
            
        case .sectionTotalHeaderViewBackground,
             .filterButtonBackground:
            return UIColor.hex(0x666666)
        }
    }
    
    func font(for element: StringElement) -> UIFont {
        switch element {
        case .cellSecondaryText,
             .sectionTotalHeaderView,
             .filterButtonText,
             .optionLabel:
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

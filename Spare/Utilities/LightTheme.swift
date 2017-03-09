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
             .expenseListSectionHeaderText,
             .mainBackground,
             .pickerFieldValue:
            return UIColor.white
            
        case .barTint,
             .expenseListCellCheckboxChecked,
             .expenseListCellAmountLabel,
             .fieldValue:
            return UIColor.black
            
        case .disclosureIndicator,
             .expenseListCellCheckboxUnchecked,
             .fieldPlaceholder,
             .tableViewSeparator:
            return UIColor.hex(0xdddddd)
            
        case .expenseListCellDetailLabel:
            return UIColor.hex(0x999999)
            
        case .expenseListSectionHeaderBackground,
             .pickerTextFieldBackground:
            return UIColor.hex(0x666666)
            
        case .fieldIcon,
             .fieldName:
            return UIColor.hex(0xbbbbbb)
        }
    }
    
}

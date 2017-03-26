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

protocol Theme {
    
    func color(for element: UIElement) -> UIColor
    
}

enum UIElement {
    case
    barBackground,
    barTint,
    commonCellMainText,
    commonCellCheckmark,
    commonCellImageButton,
    disclosureIndicator,
    elvcCellDetailText,
    elvcSectionHeaderBackground,
    elvcSectionHeaderText,
    fieldIcon,
    fieldName,
    fieldPlaceholder,
    fieldValue,
    mainBackground,
    pickerFieldValue,
    pickerTextFieldBackground,
    promptLabel,
    tableViewSeparator
}

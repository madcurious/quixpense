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
    cellMainText,
    cellSecondaryText,
    cellAccessoryIcon,
    cellAccessoryDisclosureIndicator,
    elvcSectionHeaderBackground,
    elvcSectionHeaderText,
    fieldIcon,
    fieldName,
    groupedTableViewSectionHeaderText,
    mainBackground,
    pickerFieldValue,
    pickerTextFieldBackground,
    promptLabel,
    tableViewSeparator,
    textFieldPlaceholder,
    textFieldValue
}

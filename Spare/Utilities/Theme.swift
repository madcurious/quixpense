//
//  Theme.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

enum UIElement {
    case
    barBackground,
    barTint,
    cellMainText,
    cellSecondaryText,
    cellAccessoryIcon,
    cellAccessoryDisclosureIndicator,
    
    /// Main tint color for buttons and controls.
    controlTint,
    
    elvcSectionHeaderBackground,
    elvcSectionHeaderText,
    fieldIcon,
    
    /// For labels that name a field or a setting in a grouped table view.
    fieldName,
    
    filterButtonBackground,
    filterButtonContent,
    groupedTableViewSectionHeaderText,
    mainBackground,
    pickerFieldValue,
    pickerTextFieldBackground,
    promptLabel,
    tableViewSeparator,
    textFieldPlaceholder,
    textFieldValue
}

enum StringElement {
    case
    cellSecondaryText,
    filterButtonText,
    infoLabelMainText,
    infoLabelSecondaryText,
    navBarTitle,
    optionLabel,
    regularText,
    tableViewHeader
}

protocol Theme {
    
    func color(for element: UIElement) -> UIColor
    func font(for element: StringElement) -> UIFont
    
}

protocol Themeable {
    func applyTheme()
}

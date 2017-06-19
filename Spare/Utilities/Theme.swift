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
    
    /// Main tint color for buttons and controls.
    controlTint,
    
    disclosureIndicator,
    
    homeSectionHeaderBackground,
    homeSectionHeaderText,
    
    fieldIcon,
    
    /// For labels that name a field or a setting in a grouped table view.
    fieldName,
    
    filterButtonBackground,
    filterButtonContent,
    
    mainBackground,
    pickerFieldValue,
    pickerTextFieldBackground,
    promptLabel,
    
    regularText,
    
    tableViewSeparator,
    textFieldPlaceholder,
    textFieldValue
}

enum StringElement {
    case
    cellSecondaryText,
    homeSectionHeader,
    filterButtonText,
    infoLabelMainText,
    infoLabelSecondaryText,
    navBarTitle,
    optionLabel,
    regularText
}

protocol Theme {
    
    func color(for element: UIElement) -> UIColor
    func font(for element: StringElement) -> UIFont
    
}

protocol Themeable {
    func applyTheme()
}

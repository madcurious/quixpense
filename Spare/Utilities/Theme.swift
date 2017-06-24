//
//  Theme.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

enum ColoredElement {
    case
    barBackground,
    barTint,
    
    /// Main tint color for buttons and controls.
    controlTint,
    
    disclosureIndicator,
    
    sectionTotalHeaderViewBackground,
    sectionTotalHeaderViewText,
    
    fieldIcon,
    
    groupedTableViewSectionHeader,
    
    filterButtonBackground,
    filterButtonContent,
    
    mainBackground,
    
    placeholder,
    
    promptLabel,
    
    regularText,
    
    tableViewSeparator
}

enum StringElement {
    case
    cellSecondaryText,
    dateTextFieldLabel,
    sectionTotalHeaderView,
    filterButtonText,
    loadableViewInfoLabelMainText,
    loadableViewInfoLabelSecondaryText,
    navBarTitle,
    groupedTableViewSectionHeader,
    regularText
}

protocol Theme {
    
    func color(for element: ColoredElement) -> UIColor
    func font(for element: StringElement) -> UIFont
    
}

protocol Themeable {
    func applyTheme()
}

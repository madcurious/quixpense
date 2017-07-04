//
//  Theme.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

enum ColoredElement {
    case barBackground
    case barTint
    case checkImageView
    
    /// Main tint color for buttons and controls
    case controlTint
    
    case disclosureIndicator
    case sectionTotalHeaderViewBackground
    case sectionTotalHeaderViewText
    case fieldIcon
    case filterButtonBackground
    case filterButtonContent
    case groupedTableViewSectionHeader
    case mainBackground
    case placeholder
    case promptLabel
    case regularText
    case tableViewSeparator
}

enum StringElement {
    case cellSecondaryText
    case dateTextFieldLabel
    case filterButtonText
    case groupedTableViewSectionHeader
    case loadableViewInfoLabelMainText
    case loadableViewInfoLabelSecondaryText
    case navBarTitle
    case regularText
    case sectionTotalHeaderView
}

protocol Theme {
    
    func color(for element: ColoredElement) -> UIColor
    func font(for element: StringElement) -> UIFont
    
}

protocol Themeable {
    func applyTheme()
}

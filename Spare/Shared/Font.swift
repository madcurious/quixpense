//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

enum FontWeight {
    case UltraLight, Light, Regular, Bold, ExtraBold
}

final class Font {
    
    static let BarButtonItems = Font.text(.Bold, 16)
    static let NavigationBarTitle = Font.text(.ExtraBold, 18)
    
    static let FieldLabel = Font.text(.Bold, 14)
    static let FieldValue = Font.text(.Regular, 18)
    
    static let SummaryBannerTotal = Font.text(.Bold, MDScreen.currentScreenIs(.iPhone4S, .iPhone5) ? 26 : 40)
    static let SummaryBannerDate = Font.text(.Regular, MDScreen.currentScreenIs(.iPhone4S, .iPhone5) ? 14 : 16)
    static let SummaryCellNameLabel = Font.text(.Bold, 18)
    static let SummaryCellPercentLabel = Font.text(.Regular, 10)
    static let SummaryCellTotalLabel = Font.text(.Regular, 16)
    static let SummaryFooterViewText = Font.text(.Regular, 16)
    
    class func text(weight: FontWeight, _ size: CGFloat) -> UIFont {
        switch weight {
        case .UltraLight:
            return UIFont(name: "Lato-Hairline", size: size)!
            
        case .Light:
            return UIFont(name: "Lato-Light", size: size)!
            
        case .Regular:
            return UIFont(name: "Lato-Regular", size: size)!
            
        case .Bold:
            return UIFont(name: "Lato-Bold", size: size)!
            
        case .ExtraBold:
            return UIFont(name: "Lato-Black", size: size)!
        }
    }
    
    class func icon(size: CGFloat) -> UIFont {
        return UIFont(name: "spare-v2", size: size)!
    }
    
}
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
    
    static let GraphViewTotalLabel = UIFont.boldSystemFontOfSize(26)
    static let GraphViewDetailLabel = UIFont.systemFontOfSize(16)
    static let SummaryCellCategoryLabel = UIFont.boldSystemFontOfSize(18)
    static let SummaryCellDetailLabel = UIFont.systemFontOfSize(18)
    
    // MARK: - Old fonts
    
    static let BarButtonItems = Font.text(.Bold, 14)
    static let NavigationBarTitle = Font.text(.ExtraBold, 18)
    
    static let ExpenseListCellItemDescriptionLabel = Font.text(.Regular, 18)
    static let ExpenseListCellDetailLabel = Font.text(.Regular, 16)
    static let ExpenseListFooterViewLabel = Font.text(.Regular, 16)
    static let ExpenseListHeaderViewDetailLabel = Font.text(.Regular, 18)
    static let ExpenseListHeaderViewNameLabel = Font.text(.Bold, 30)
    
    static let FieldLabel = Font.text(.Bold, 14)
    static let FieldValue = Font.text(.Regular, 18)
    
    static let HomeBarButtonItem = Font.text(.Bold, 18)
    
    static let SummaryBannerTotal = Font.text(.Bold, MDScreen.currentScreenIs(.iPhone4S, .iPhone5) ? 26 : 32)
    static let SummaryBannerDate = Font.text(.Regular, MDScreen.currentScreenIs(.iPhone4S, .iPhone5) ? 14 : 16)
    static let SummaryCellBadge = Font.text(.Bold, 10)
    static let SummaryCellNameLabel = Font.text(.Bold, 18)
    static let SummaryCellPercentLabel = Font.text(.Regular, 12)
    static let SummaryCellTotalLabel = Font.text(.Regular, 18)
    static let SummaryFooterViewText = Font.text(.Regular, 16)
    static let SummarySectionHeaderSectionLabel = Font.text(.Bold, 14)
    static let SummarySectionHeaderRightButton = Font.text(.Bold, 12)
    
    static let TiledSummaryCellNameLabel = Font.text(.Bold, 24)
    static let TiledSummaryCellTotalLabel = Font.text(.Regular, 20)
    static let TiledSummaryCellPercentLabel = Font.text(.Regular, 20)
    
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
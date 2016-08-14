//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

enum Weight: String {
    
    case Medium = "Medium"
    case Heavy = "Heavy"
    
}

final class Font {
    
    static let AnySize = CGFloat(18)
    
    static let CustomPickerText = Font.make(.Medium, 20)
    
    static let ExpenseEditorCurrencyLabel = Font.make(.Heavy, AnySize)
    static let ExpenseEditorAmountValue = Font.make(.Heavy, AnySize)
    static let ExpenseEditorKeypadText = Font.make(.Heavy, AnySize)
    
    static let FieldLabel = Font.make(.Heavy, 14)
    static let FieldValue = Font.make(.Medium, 20)
    
    static let ModalBarButtonText = Font.make(.Medium, 17)
    static let NavBarTitle = Font.make(.Heavy, 19)
    
    class func make(weight: Weight, _ size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-\(weight.rawValue)", size: size)!
    }
    
    class func icon(size: CGFloat) -> UIFont {
        return UIFont(name: "spare-v2", size: size)!
    }
    
    // MARK: - Old fonts
    
    static let ExpenseListCellText = UIFont.systemFontOfSize(18)
    static let ExpenseListEmptyViewPromptLabel = UIFont.systemFontOfSize(18)
    static let ExpenseListHeaderNameLabel = UIFont.boldSystemFontOfSize(30)
    static let ExpenseListHeaderDetailLabel = UIFont.systemFontOfSize(18)
    
    static let FormValue = UIFont.systemFontOfSize(18)
    
    static let GraphViewTotalLabel = UIFont.boldSystemFontOfSize(26)
    static let GraphViewDetailLabel = UIFont.systemFontOfSize(16)
    
    static let StatefulVCRetryViewMessageLabel = UIFont.systemFontOfSize(18)
    
    static let SummaryCellTextLabel = UIFont.systemFontOfSize(18)
    
    static let BarButtonItems = Font.text(.Bold, 14)
    static let NavigationBarTitle = Font.text(.ExtraBold, 18)
    
    static let ExpenseListCellItemDescriptionLabel = Font.text(.Regular, 18)
    static let ExpenseListCellDetailLabel = Font.text(.Regular, 16)
    static let ExpenseListFooterViewLabel = Font.text(.Regular, 16)
    static let ExpenseListHeaderViewDetailLabel = Font.text(.Regular, 18)
    static let ExpenseListHeaderViewNameLabel = Font.text(.Bold, 30)
    
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
    
}

// Delete

enum FontWeight {
    case UltraLight, Light, Regular, Bold, ExtraBold
}
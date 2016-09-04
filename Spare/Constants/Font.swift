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
    
    case Book = "Book"
    case Medium = "Medium"
    case Heavy = "Heavy"
    
}

final class Font {
    
    static let AnySize = CGFloat(18)
    
    static let CustomPickerText = Font.make(.Medium, 18)
    static let CustomPickerHeaderText = Font.make(.Heavy, 15)
    
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
    
}

// Delete

enum FontWeight {
    case UltraLight, Light, Regular, Bold, ExtraBold
}
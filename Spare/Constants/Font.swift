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
    
    class func make(_ weight: Weight, _ size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-\(weight.rawValue)", size: size)!
    }
    
    class func icon(_ size: CGFloat) -> UIFont {
        return UIFont(name: "spare-v2", size: size)!
    }
    
    // MARK: - Old fonts
    
    static let ExpenseListCellText = UIFont.systemFont(ofSize: 18)
    static let ExpenseListEmptyViewPromptLabel = UIFont.systemFont(ofSize: 18)
    static let ExpenseListHeaderNameLabel = UIFont.boldSystemFont(ofSize: 30)
    static let ExpenseListHeaderDetailLabel = UIFont.systemFont(ofSize: 18)
    
    static let FormValue = UIFont.systemFont(ofSize: 18)
    
    static let GraphViewTotalLabel = UIFont.boldSystemFont(ofSize: 26)
    static let GraphViewDetailLabel = UIFont.systemFont(ofSize: 16)
    
    static let SummaryCellTextLabel = UIFont.systemFont(ofSize: 18)
    
}

// Delete

enum FontWeight {
    case ultraLight, light, regular, bold, extraBold
}

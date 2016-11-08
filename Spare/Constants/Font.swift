//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

final class Font {
    
    enum Weight: String {
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case italic = "Italic"
        case regular = "Regular"
    }
    
    static let AnySize = CGFloat(18)
    
    static let CustomPickerText = Font.make(.regular, 18)
    static let CustomPickerHeaderText = Font.make(.bold, 15)
    
    static let ExpenseEditorKeypadText = Font.make(.bold, AnySize)
    
    static let FieldLabel = Font.make(.bold, 14)
    static let FieldValue = Font.make(.regular, 20)
    
    static let ModalBarButtonText = Font.make(.regular, 17)
    static let NavBarTitle = Font.make(.bold, 19)
    
    class func make(_ weight: Weight, _ size: CGFloat) -> UIFont {
        var fontName = "NotoSansUI"
        switch weight {
        case .bold, .boldItalic, .italic:
            fontName += "-\(weight.rawValue)"
            
        default:
            break
        }
        print(UIFont.fontNames(forFamilyName: "Noto Sans UI"))
        return UIFont(name: fontName, size: size)!
    }
    
    class func makeIcon(size: CGFloat) -> UIFont {
        return UIFont(name: "spare-icons", size: size)!
    }
    
}

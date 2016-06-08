//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

enum FontWeight {
    case Light, Regular, Bold, ExtraBold
}

final class Font {
    
    static let BarButtonItems = Font.text(.Bold, 14)
    static let NavigationBarTitle = Font.text(.Bold, 18)
    
    static let FieldLabel = Font.text(.Bold, 14)
    static let FieldValue = Font.text(.Light, 18)
    
    class func text(weight: FontWeight, _ size: CGFloat) -> UIFont {
        switch weight {
        case .Light:
            return UIFont(name: "Montserrat-Light", size: size)!
            
        case .Regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
            
        case .Bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
            
        case .ExtraBold:
            return UIFont(name: "Montserrat-ExtraBold", size: size)!
        }
    }
    
    class func icon(size: CGFloat) -> UIFont {
        return UIFont(name: "spare-v2", size: size)!
    }
    
}
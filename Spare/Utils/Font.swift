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
    
    static let FieldLabel = Font.get(.Bold, size: 14)
    static let FieldValue = Font.get(.Light, size: 18)
    
    class func get(weight: FontWeight, size: CGFloat) -> UIFont {
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
    
}
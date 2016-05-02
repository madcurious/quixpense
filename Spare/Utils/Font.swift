//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

enum FontWeight {
    case Regular, Bold, ExtraBold
}

final class Font {
    
    class func get(weight: FontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .Regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
            
        case .Bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
            
        case .ExtraBold:
            return UIFont(name: "Montserrat-ExtraBold", size: size)!
        }
    }
    
}
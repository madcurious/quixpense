//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 02/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

final class Font {
    
    enum Weight {
        case Regular, Bold
    }
    
    class func get(weight: Weight, size: CGFloat) -> UIFont {
        switch weight {
        case .Regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
            
        case.Bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
        }
    }
    
}
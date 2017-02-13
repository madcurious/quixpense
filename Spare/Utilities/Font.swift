//
//  Font.swift
//  Spare
//
//  Created by Matt Quiros on 14/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

struct Font {
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansUI-Bold", size: size)!
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansUI-Regular", size: size)!
    }
    
}


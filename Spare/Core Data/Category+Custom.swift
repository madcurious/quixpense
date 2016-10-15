//
//  Category+Custom.swift
//  Spare
//
//  Created by Matt Quiros on 15/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

extension Category {
    
    var color: UIColor {
        return UIColor(hex: self.colorHex!.intValue)
    }
    
}

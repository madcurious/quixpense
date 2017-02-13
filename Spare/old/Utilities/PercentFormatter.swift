//
//  PercentFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

final class PercentFormatter {
    
    fileprivate init() {}
    
    class func displayText(for percentage: CGFloat) -> String {
        return String(format: "%.0f%%", percentage * 100)
    }
    
}

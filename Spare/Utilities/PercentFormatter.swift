//
//  PercentFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

final class PercentFormatter {
    
    private init() {}
    
    class func displayTextForPercent(percent: Double) -> String {
        return String(format: "%.0f%%", percent * 100)
    }
    
}
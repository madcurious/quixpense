//
//  Periodization.swift
//  Spare
//
//  Created by Matt Quiros on 14/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

enum Periodization: Int {
    
    case day = 0, week, month, year
    
    var descriptiveText: String {
        switch self {
        case .day:
            return "Daily"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        }
    }
    
}

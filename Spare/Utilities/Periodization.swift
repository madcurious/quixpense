//
//  Periodization.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

enum Periodization: Int {
    
    case day = 0, week, month
    
    func text() -> String {
        switch self {
        case .day:
            return "Daily"
            
        case .week:
            return "Weekly"
            
        case .month:
            return "Monthly"
        }
    }
    
}

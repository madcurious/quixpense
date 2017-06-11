//
//  Filter.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

func ==(lhs: Filter, rhs: Filter) -> Bool {
    return lhs.periodization == rhs.periodization &&
        lhs.grouping == rhs.grouping
}

struct Filter: Equatable {
    
    enum Periodization: Int16 {
        case day = 1, week, month
        
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
        
        func toInt() -> Int {
            return Int(self.rawValue)
        }
    }
    
    enum Grouping: Int16 {
        case category = 1, tag
        
        func text() -> String {
            switch self {
            case .category:
                return "by category"
                
            case .tag:
                return "by tag"
            }
        }
        
        func toInt() -> Int {
            return Int(self.rawValue)
        }
    }
    
    var periodization = Periodization.day
    var grouping = Grouping.category
    
    func text() -> String {
        return "\(self.periodization.text()), \(self.grouping.text())"
    }
    
}

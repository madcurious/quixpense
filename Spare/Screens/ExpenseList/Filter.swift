//
//  Filter.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

struct Filter {
    
    enum Periodization {
        case Daily, Weekly, Monthly
        
        func text() -> String {
            switch self {
            case .Daily:
                return "Daily"
                
            case .Weekly:
                return "Weekly"
                
            case .Monthly:
                return "Monthly"
            }
        }
    }
    
    enum Grouping {
        case Categories, Tags
        
        func text() -> String {
            switch self {
            case .Categories:
                return "by category"
                
            case .Tags:
                return "by tag"
            }
        }
    }
    
    var periodization = Periodization.Daily
    var grouping = Grouping.Categories
    
    func text() -> String {
        return "\(self.periodization.text()), \(self.grouping.text())"
    }
    
}

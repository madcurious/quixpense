//
//  ExpenseListFilter.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

struct ExpenseListFilter {
    
    enum Periodization {
        case Daily, Weekly, Monthly
    }
    
    enum Grouping {
        case Categories, Tags
    }
    
    var periodization: Periodization
    var grouping: Grouping
    
}

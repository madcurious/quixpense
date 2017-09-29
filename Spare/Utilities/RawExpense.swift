//
//  RawExpense.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

/// Represents a user-entered expense.
struct RawExpense {
    
    var amount: String?
    var dateSpent = Date()
    var categorySelection = CategorySelection.none
    var tagSelection = TagSelection.none
    
}

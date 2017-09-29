//
//  ValidExpense.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

/**
 Represents a user-entered expense that has passed validation and may already be
 inserted into the persistent store.
 */
struct ValidExpense {
    
    let amount: NSDecimalNumber
    let dateSpent: Date
    let categorySelection: CategorySelection
    let tagSelection: TagSelection
    
}

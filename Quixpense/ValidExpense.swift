//
//  ValidExpense.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

/**
 Represents a user-entered expense that has passed validation and may already be
 inserted into the persistent store.
 */
struct ValidExpense {
    
    let amount: NSDecimalNumber
    let dateSpent: Date
    let category: String
    let tags: [String]
    
}

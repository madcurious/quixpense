//
//  DeleteExpenseTestCase.swift
//  SpareTests
//
//  Created by Matt Quiros on 06/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
@testable import Spare

class DeleteExpenseTestCase: CoreDataTestCase {
    
    func makeExpenses() {
        let rawExpenses = [
            RawExpense(amount: "200", dateSpent: Date(), category: "Food", tags: ["credit", "eat out"]),
            RawExpense(amount: "120", dateSpent: Date(), category: "Food", tags: ["coffee", "rewards card"]),
            RawExpense(amount: "149.99", dateSpent: Date(), category: "Food", tags: ["cash"]),
            RawExpense(amount: "88.94", dateSpent: Date(), category: "Transpo", tags: ["rideshare"]),
            RawExpense(amount: "15", dateSpent: Date(), category: "Transpo", tags: ["puv"]),
            RawExpense(amount: "8", dateSpent: Date(), category: "Transpo", tags: ["puv"]),
            RawExpense(amount: "1875", dateSpent: Date(), category: "Medicines", tags: ["fiber"])
        ]
        let validExpenses = rawExpenses.map({ makeValidExpense(from: $0) })
        for expense in validExpenses {
            let context = coreDataStack.newBackgroundContext()
            AddExpenseOperation(context: context, validExpense: expense, completionBlock: nil).start()
        }
    }
    
}

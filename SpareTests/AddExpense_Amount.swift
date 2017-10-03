//
//  AddExpense_Amount.swift
//  SpareTests
//
//  Created by Matt Quiros on 29/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class AddExpense_Amount: CoreDataTestCase {
    
    func testAmount_validAmount_shouldSucceed() {
        let rawExpense = RawExpense(amount: "250.00",
                                    dateSpent: Date(),
                                    categorySelection: .none,
                                    tagSelection: .none)
        let validExpense = makeValidExpense(from: rawExpense)
        
        let category = AddExpenseOperation.fetchExistingCategory(forSelection: validExpense.categorySelection, in: coreDataStack.viewContext)
        let uncategorized: Spare.Category? = {
            let fetchRequest: NSFetchRequest<Spare.Category> = Spare.Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Spare.Category.name), DefaultClassifier.defaultCategoryName)
            return try! coreDataStack.viewContext.fetch(fetchRequest).first
        }()
        
        XCTAssertNotNil(category)
        XCTAssertNotNil(uncategorized)
        XCTAssertEqual(category?.objectID, uncategorized?.objectID)
        XCTAssertEqual(category?.name, DefaultClassifier.defaultCategoryName)
    }
    
}

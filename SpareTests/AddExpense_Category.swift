//
//  AddExpense_Category.swift
//  SpareTests
//
//  Created by Matt Quiros on 16/10/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class AddExpense_Category: CoreDataTestCase {
    
    func test_noCategory_shouldReturnUncategorized() {
        let validExpense = makeValidExpense(from: RawExpense(amount: "200",
                                                             dateSpent: Date(),
                                                             categorySelection: .none,
                                                             tagSelection: .none))
        let context = coreDataStack.newBackgroundContext()
        let category = AddExpenseOperation.category(forSelection: .new(validExpense.categorySelection), in: context)
        XCTAssertNotNil(category)
        XCTAssertEqual(category.name, DefaultClassifier.noCategory.classifierName)
    }
    
}

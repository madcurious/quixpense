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
                                                             category: nil,
                                                             tags: nil))
        XCTAssertEqual(validExpense.category, DefaultClassifier.noCategory.classifierName)
    }
    
}

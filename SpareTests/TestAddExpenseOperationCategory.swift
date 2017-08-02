//
//  TestAddExpenseOperationCategory.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
import Mold
@testable import Spare

class TestAddExpenseOperationCategory: CoreDataTestCase {
    
    override func setUp() {
        super.setUp()
        
        guard let coreDataStack = coreDataStack
            else {
                XCTFail("Core data stack is nil. Why?")
                return
        }
        
        let categoryNames = [
            "Food and Drinks",
            "Transportation",
            "Utilities",
            "Medicines"
        ]
        let context = coreDataStack.newBackgroundContext()
        for name in categoryNames {
            let category = Category(context: context)
            category.name = name
        }
        do {
            try context.saveToStore()
        } catch {
            XCTFail("Error saving in-memory CoreData stack: \(error)")
        }
    }
    
    func testSelectedObjectID() {
        guard let coreDataStack = coreDataStack
            else {
                XCTFail("Core data stack is nil. Why?")
                return
        }
        
        let selectedCategoryName = "Transportation"
        let fetchRequest: NSFetchRequest<Spare.Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Spare.Category.name), selectedCategoryName)
        do {
            if let existingCategory = try coreDataStack.viewContext.fetch(fetchRequest).first {
                let enteredData = ExpenseFormViewController.EnteredData(amount: "100.00", date: Date(), category: .id(existingCategory.objectID), tags: .none)
                
                let addContext = coreDataStack.newBackgroundContext()
                let xp = expectation(description: "\(#function)\(#line)")
                let addOp = AddExpenseOperation(context: addContext, enteredData: enteredData) { result in
                    switch result {
                    case .error(let error):
                        XCTFail("Add expense error found: \(error.localizedDescription)")
                        
                    case .none:
                        XCTFail("Add expense returned no results")
                        
                    case .success(let objectID):
                        if let expense = coreDataStack.viewContext.object(with: objectID) as? Expense {
                            guard let expenseCategory = expense.category
                                else {
                                    XCTFail("Expense category is nil! Expense ID: \(objectID)")
                                    return
                            }
                            XCTAssertTrue(expenseCategory.objectID == existingCategory.objectID, "Wrong category ID selected")
                        } else {
                            XCTFail("Add expense succeeded but can't find new expense object ID: \(objectID)")
                        }
                    }
                    xp.fulfill()
                }
                operationQueue.addOperation(addOp)
                waitForExpectations(timeout: 30, handler: nil)
            } else {
                XCTFail("No category '\(selectedCategoryName)' found.")
            }
        } catch {
            XCTFail("Core Data fetch error: \(error)")
        }
    }
    
    func testEnteredName() {
        
    }
    
    func testUncategorized() {
        
    }
    
}

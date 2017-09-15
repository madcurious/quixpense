//
//  EditExpenseTest_Category.swift
//  SpareTests
//
//  Created by Matt Quiros on 14/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class EditExpenseTest_Category: CoreDataTestCase {
    
    func makeDummyExpenses() {
        let dummy = [
            ("250.00", "Food"),
            ("164.11", "Transportation")
        ]
        var operations = [AddExpenseOperation]()
        for (amount, categoryName) in dummy {
            let enteredExpense = EnteredExpense(amount: amount, date: Date(), categorySelection: .name(categoryName), tagSelection: .none)
            let addOp = AddExpenseOperation(context: coreDataStack.newBackgroundContext(), enteredExpense: enteredExpense, completionBlock: nil)
            operations.append(addOp)
        }
        operationQueue.addOperations(operations, waitUntilFinished: true)
    }
    
    // MARK: - Entered name
    
    func testEnteredName_sameAsCurrentCategoryName_shouldSucceedWithoutEditingCategory() {
        makeDummyExpenses()
        
        // Get the first expense.
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        guard let expense = (try? coreDataStack.viewContext.fetch(fetchRequest))?.first
            else {
                XCTFail()
                return
        }
        
        let enteredEdit = EnteredExpense(amount: "999", date: Date(), categorySelection: .name("Food"), tagSelection: .none)
        
        let xp = expectation(description: #function)
        let editOp = EditExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                          expenseId: expense.objectID,
                                          enteredExpense: enteredEdit) {[weak self] result in
                                            defer {
                                                xp.fulfill()
                                            }
                                            switch result {
                                            case .success(let objectId):
                                                XCTAssertEqual(objectId, expense.objectID)
                                                let editedExpense = self?.coreDataStack.viewContext.object(with: objectId) as! Expense
                                                XCTAssertEqual(NSDecimalNumber(value: 999), editedExpense.amount)
                                            default:
                                                XCTFail()
                                            }
        }
        operationQueue.addOperation(editOp)
        waitForExpectations(timeout: 100000, handler: nil)
    }
    
    func testEnteredName_alreadyExists_shouldFail() {
        
    }
    
    func testEnteredName_sameNameDifferentLetterCase_shouldAddNewCategory() {
        
    }
    
    func testEnteredName_emptyString_shouldFail() {
        
    }
    
    func testEnteredName_nilString_shouldFail() {
        
    }
    
    func testThatCategoryIsValidFromSelectedId() {
        
    }
    
    func testThatCategoryIsUncategorizedFromBlank() {
        
    }
    
}

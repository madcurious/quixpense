//
//  EditExpense_Category.swift
//  SpareTests
//
//  Created by Matt Quiros on 14/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class EditExpense_Category: CoreDataTestCase {
    
    func makeDummyExpenses() {
        let dummy = [
            ("250.00", "Food"),
            ("164.11", "Transportation")
        ]
        var operations = [AddExpenseOperation]()
        for (amount, categoryName) in dummy {
            let enteredExpense = EnteredExpense(amount: amount, dateSpent: Date(), categorySelection: .name(categoryName), tagSelection: .none)
            let addOp = AddExpenseOperation(context: coreDataStack.newBackgroundContext(), enteredExpense: enteredExpense, completionBlock: nil)
            operations.append(addOp)
        }
        operationQueue.addOperations(operations, waitUntilFinished: true)
    }
    
    // MARK: - Entered name
    
    func testEnteredName_sameAsCurrentCategoryName_shouldNotChange() {
        makeDummyExpenses()
        
        // Get the first expense.
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        guard let expense = (try? coreDataStack.viewContext.fetch(fetchRequest))?.first
            else {
                XCTFail()
                return
        }
        
        let enteredExpense = EnteredExpense(amount: "999", dateSpent: Date(), categorySelection: .name("Food"), tagSelection: .none)
        let validateOp = ValidateEnteredExpenseOperation(enteredExpense: enteredExpense, context: coreDataStack.newBackgroundContext(), completionBlock: nil)
        validateOp.start()
        
        guard case .success(let validEnteredExpense) = validateOp.result
            else {
            fatalError()
        }
        
        let editOp = EditExpenseOperation(context: coreDataStack.viewContext,
                                          expenseId: expense.objectID,
                                          validEnteredExpense: validEnteredExpense,
                                          completionBlock: nil)
        let currentCategory = editOp.fetchExpense()?.category
        let shouldChange = editOp.shouldChange(currentCategory: currentCategory, from: validEnteredExpense.categorySelection)
        XCTAssertFalse(shouldChange)
        
        // Actually perform operation
        editOp.start()
        guard case .success(let expenseId) = editOp.result,
            let editedExpense = coreDataStack.viewContext.object(with: expenseId) as? Expense
            else {
                fatalError()
        }
        XCTAssertEqual(editedExpense.category?.name, "Food")
    }
    
}

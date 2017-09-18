//
//  EditExpense_DateSpent.swift
//  SpareTests
//
//  Created by Matt Quiros on 18/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class EditExpense_DateSpent: CoreDataTestCase {
    
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
    
    func makeFetchedResultsController() -> NSFetchedResultsController<Expense> {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Expense.dateSpent), ascending: true)
        ]
        let frc = NSFetchedResultsController<Expense>(fetchRequest: request,
                                                      managedObjectContext: coreDataStack.viewContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
        return frc
    }
    
    func makeValidEnteredExpense(from enteredExpense: EnteredExpense) -> ValidEnteredExpense {
        let validateOp = ValidateEnteredExpenseOperation(enteredExpense: enteredExpense, context: coreDataStack.newBackgroundContext(), completionBlock: nil)
        validateOp.start()
        if case .success(let validEnteredExpense) = validateOp.result {
            return validEnteredExpense
        }
        fatalError()
    }
    
}

extension EditExpense_DateSpent {
    
    func testDateSpent_newDate_shouldChangeClassifierGroups() {
        makeDummyExpenses()
        let frc = makeFetchedResultsController()
        try! frc.performFetch()
        let firstExpense = frc.fetchedObjects!.first!
        let newDate = Date(timeIntervalSince1970: 1459468800)
        let validEnteredExpense = makeValidEnteredExpense(from: EnteredExpense(amount: "333.45",
                                                                               dateSpent: newDate,
                                                                               categorySelection: .none,
                                                                               tagSelection: .none))
        let editOp = EditExpenseOperation(context: coreDataStack.viewContext,
                                          expenseId: firstExpense.objectID,
                                          validEnteredExpense: validEnteredExpense,
                                          completionBlock: nil)
        let expenseToEdit = editOp.fetchExpense()!
        
        let shouldChangeDate = editOp.shouldChangeDateSpent(expenseToEdit.dateSpent, with: newDate)
        XCTAssertTrue(shouldChangeDate)
    }
    
}

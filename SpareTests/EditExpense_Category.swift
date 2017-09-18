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
    
    // MARK: - Entered name
    
    func testEnteredName_sameAsCurrentCategoryName_shouldNotChange() {
        makeDummyExpenses()
        
        // Get the first expense.
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Expense.category.name), "Food")
        guard let expense = (try? coreDataStack.viewContext.fetch(fetchRequest))?.first
            else {
                XCTFail()
                return
        }
        
        let enteredExpense = EnteredExpense(amount: "999", dateSpent: expense.dateSpent!, categorySelection: .name("Food"), tagSelection: .none)
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
    
    func testEnteredName_usingExistingCategory_shouldUpdateClassifierAndClassifierGroups() {
        makeDummyExpenses()
        let frc = makeFetchedResultsController()
        try! frc.performFetch()
        let expense0 = frc.fetchedObjects!.first!
        let expense1 = frc.object(at: IndexPath(row: 1, section: 0))
        let newCategoryEnteredName = expense1.category!.name!
        let validEnteredExpense = makeValidEnteredExpense(from: EnteredExpense(amount: "333.45",
                                                                           dateSpent: expense1.dateSpent!,
                                                                           categorySelection: .name(newCategoryEnteredName),
                                                                           tagSelection: .none))
        let editOp = EditExpenseOperation(context: coreDataStack.viewContext,
                                          expenseId: expense0.objectID,
                                          validEnteredExpense: validEnteredExpense,
                                          completionBlock: nil)
        var expenseToEdit = editOp.fetchExpense()!
        
        let shouldChange = editOp.shouldChange(currentCategory: expenseToEdit.category, from: validEnteredExpense.categorySelection)
        XCTAssertTrue(shouldChange)
        
        let replacementCategory = editOp.fetchOrMakeReplacementCategory(fromSelection: validEnteredExpense.categorySelection)
        XCTAssertEqual(replacementCategory.name, newCategoryEnteredName)
        XCTAssertEqual(replacementCategory.name, expense1.category?.name)
        XCTAssertEqual(replacementCategory.objectID, expense1.category?.objectID)
        
        let currentDayCategoryGroup = expenseToEdit.dayCategoryGroup
        let currentWeekCategoryGroup = expenseToEdit.weekCategoryGroup
        let currentMonthCategoryGroup = expenseToEdit.monthCategoryGroup
        
        let newDayCategoryGroup = editOp.fetchReplacementClassifierGroup(periodization: .day, classifier: replacementCategory, dateSpent: validEnteredExpense.dateSpent)
        XCTAssertNotNil(newDayCategoryGroup)
        XCTAssertEqual(expense1.dayCategoryGroup, newDayCategoryGroup)
        XCTAssertNotEqual(currentDayCategoryGroup, newDayCategoryGroup)
        
        let newWeekCategoryGroup = editOp.fetchReplacementClassifierGroup(periodization: .week, classifier: replacementCategory, dateSpent: validEnteredExpense.dateSpent)
        XCTAssertNotNil(newWeekCategoryGroup)
        XCTAssertEqual(expense1.weekCategoryGroup, newWeekCategoryGroup)
        XCTAssertNotEqual(currentWeekCategoryGroup, newWeekCategoryGroup)
        
        let newMonthCategoryGroup = editOp.fetchReplacementClassifierGroup(periodization: .month, classifier: replacementCategory, dateSpent: validEnteredExpense.dateSpent)
        XCTAssertNotNil(newMonthCategoryGroup)
        XCTAssertEqual(expense1.monthCategoryGroup, newMonthCategoryGroup)
        XCTAssertNotEqual(currentMonthCategoryGroup, newMonthCategoryGroup)
        
        // Perform operation
        
        editOp.start()
        if case .success(let objectId) = editOp.result {
            expenseToEdit = coreDataStack.viewContext.object(with: objectId) as! Expense
            XCTAssertEqual(expenseToEdit.dayCategoryGroup, newDayCategoryGroup)
            XCTAssertEqual(expenseToEdit.weekCategoryGroup, newWeekCategoryGroup)
            XCTAssertEqual(expenseToEdit.monthCategoryGroup, newMonthCategoryGroup)
        } else {
            XCTFail()
        }
    }
    
}

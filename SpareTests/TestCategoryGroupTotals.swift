//
//  TestCategoryGroupTotals.swift
//  SpareTests
//
//  Created by Matt Quiros on 04/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
import Mold
@testable import Spare

class TestCategoryGroupTotals: CoreDataTestCase {
    
    override func setUp() {
        super.setUp()
        
        let xp = expectation(description: #function)
        
        var startOfJune2017 = DateComponents()
        startOfJune2017.month = 6
        startOfJune2017.day = 1
        startOfJune2017.year = 2017
        let dummyDataOp = MakeDummyDataOperation(from: .date(Calendar.current.date(from: startOfJune2017)!)) { _ in
            xp.fulfill()
        }
        operationQueue.addOperation(dummyDataOp)
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testDayCategoryGroup() {
        let categoryName = "Food and Drinks"
        let dateSpent = Date()
        let currentTotal: NSDecimalNumber = {
            let sectionIdentifier = SectionIdentifier.make(startDate: dateSpent.startOfDay(), endDate: dateSpent.endOfDay())
            let fetchRequest: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                                 #keyPath(DayCategoryGroup.sectionIdentifier), sectionIdentifier,
                                                 #keyPath(DayCategoryGroup.classifier.name), categoryName
            )
            let existingGroup = try! coreDataStack.viewContext.fetch(fetchRequest).first!
            return existingGroup.total!
        }()
        
        let context = coreDataStack.newBackgroundContext()
        let enteredData = ExpenseFormViewController.EnteredData(amount: "456.15", date: dateSpent, category: .name(categoryName), tags: .none)
        let xp = expectation(description: #function)
        let addOp = AddExpenseOperation(context: context, enteredData: enteredData) {[unowned self] (result) in
            defer {
                xp.fulfill()
            }
            
            guard case .success(let objectID) = result
                else {
                    XCTFail("add operation failed")
                    return
            }
            
            guard let expense = self.coreDataStack.viewContext.object(with: objectID) as? Expense,
                let dayCategoryGroup = expense.dayCategoryGroup,
                let groupTotal = dayCategoryGroup.total,
                let groupExpenses = dayCategoryGroup.expenses as? Set<Expense>,
                let groupExpensesTotal: NSDecimalNumber = groupExpenses.reduce(NSDecimalNumber(value: 0), { $0.adding($1.amount!) })
                else {
                    XCTFail("Add operation succeeded but expense model incomplete")
                    return
            }
            
            let runningTotal = currentTotal + expense.amount!
            XCTAssert(runningTotal == groupTotal, "Running total is not the same")
            XCTAssert(groupTotal == groupExpensesTotal, "groupTotal should be equal to computed total")
            XCTAssert(runningTotal == groupExpensesTotal, "runningTotal should be equal to groupExpensesTotal")
        }
        operationQueue.addOperation(addOp)
        waitForExpectations(timeout: 60, handler: nil)
    }
    
}

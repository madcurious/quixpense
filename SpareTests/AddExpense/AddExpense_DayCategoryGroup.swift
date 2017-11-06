//
//  class AddExpense_DayCategoryGroup.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/10/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Bedrock
import CoreData
@testable import Spare

class AddExpense_DayCategoryGroup: CoreDataTestCase {
    
    func testSectionIdentifier_shouldSucceed() {
        var components = DateComponents()
        components.day = 30
        components.month = 9
        components.year = 2017
        let date = Calendar.current.date(from: components)!
        let identifier = SectionIdentifier.make(referenceDate: date, periodization: .day)
        XCTAssertEqual(identifier, "\(Calendar.current.startOfDay(for: date).timeIntervalSince1970)-\(BRDateUtil.endOfDay(for: date).timeIntervalSince1970)")
    }
    
    func test_notYetExisting_shouldBeCreated() {
        let date = makeDate(day: 30, month: 9, year: 2017)
        let sectionId = SectionIdentifier.make(referenceDate: date, periodization: .day)
        let categoryName = "Transportation"
        
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(DayCategoryGroup.sectionIdentifier), sectionId,
                                             #keyPath(DayCategoryGroup.classifier.name), categoryName
        )
        XCTAssertNil(try! context.fetch(fetchRequest).first)
        
        let validExpense = makeValidExpense(from: RawExpense(amount: "200", dateSpent: date, category: categoryName, tags: nil))
        let addOp = AddExpenseOperation(context: context, validExpense: validExpense, completionBlock: nil)
        addOp.start()
        
        let group = try! context.fetch(fetchRequest).first
        XCTAssertNotNil(group)
        XCTAssertEqual(group?.sectionIdentifier, sectionId)
        XCTAssertEqual(group?.total, NSDecimalNumber(value: 200))
        XCTAssertEqual(group?.classifier?.name, categoryName)
        XCTAssertEqual(group?.expenses?.count, 1)
    }
    
    func test_totalIsCorrect_shouldPass() {
        let context = coreDataStack.newBackgroundContext()
        let sectionIdentifier = SectionIdentifier.make(referenceDate: Date(), periodization: .day)
        
        let category = Category(context: context)
        category.name = "Transportation"
        
        let dayCategoryGroup = DayCategoryGroup(context: context)
        dayCategoryGroup.sectionIdentifier = sectionIdentifier
        dayCategoryGroup.total = NSDecimalNumber(value: 1000)
        dayCategoryGroup.classifier = category
        
        try! context.saveToStore()
        
        let validExpense = makeValidExpense(from: RawExpense(amount: "1875.25", dateSpent: Date(), category: "Transportation", tags: nil))
        let addOp = AddExpenseOperation(context: context, validExpense: validExpense, completionBlock: nil)
        addOp.start()
        
        guard let result = addOp.result
            else {
                XCTFail(BRTest.fail(#function, type: .noResult))
                return
        }
        
        switch result {
        case .success(let expenseId):
            guard let expense = coreDataStack.viewContext.object(with: expenseId) as? Expense,
                let expenseDayCategoryGroup = expense.dayCategoryGroup
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            XCTAssertEqual(expenseDayCategoryGroup.total, NSDecimalNumber(value: 2875.25))
            
        case .error(let error):
            XCTFail("\(#function) - Error: \(error)")
        }
    }
    
    func test_categoryIsCorrect_shouldPass() {
        let context = coreDataStack.newBackgroundContext()
        let validExpense = makeValidExpense(from:
            RawExpense(amount: "500.75",
                       dateSpent: makeDate(day: 26, month: 09, year: 2017, hour: 16, minute: 17, second: 00),
                       category: "Food",
                       tags: nil)
        )
        let addOp = AddExpenseOperation(context: context, validExpense: validExpense, completionBlock: nil)
        addOp.start()
        
        guard let result = addOp.result
            else {
                XCTFail("No result - \(#function)")
                return
        }
        
        switch result {
        case .error(let error):
            XCTFail(BRTest.fail(#function, type: .error(error)))
            
        case .success(let expenseId):
            let expense = coreDataStack.viewContext.object(with: expenseId) as! Expense
            if let classifierName = expense.dayCategoryGroup?.classifier?.name {
                XCTAssertEqual("Food", classifierName)
            } else {
                XCTFail(BRTest.fail(#function, type: .nil))
            }
        }
    }
    
    func test_containsExpense_shouldPass() {
        let validExpenses = [
            makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Food", tags: nil)),
            makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Transpo", tags: nil)),
            makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Transpo", tags: nil)),
            makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Food", tags: nil)),
            makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Food", tags: nil))
        ]
        
        for expense in validExpenses {
            let context = coreDataStack.newBackgroundContext()
            let addOp = AddExpenseOperation(context: context, validExpense: expense, completionBlock: nil)
            addOp.start()
        }
        
        let context = coreDataStack.newBackgroundContext()
        let newExpense = makeValidExpense(from: RawExpense(amount: "443.17", dateSpent: Date(), category: "Food", tags: nil))
        let addOp = AddExpenseOperation(context: context, validExpense: newExpense, completionBlock: nil)
        addOp.start()
        
        guard let result = addOp.result
            else {
                XCTFail(BRTest.fail(#function, type: .noResult))
                return
        }
        
        switch result {
        case .error(let error):
            XCTFail(BRTest.fail(#function, type: .error(error)))
            
        case .success(let objectId):
            let expense = coreDataStack.viewContext.object(with: objectId) as! Expense
            guard let expenses = expense.dayCategoryGroup?.expenses
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            XCTAssertEqual(expenses.count, 4)
            XCTAssertTrue(expenses.contains(expense))
        }
    }
    
}

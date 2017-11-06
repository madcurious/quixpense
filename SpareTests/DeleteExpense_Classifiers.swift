//
//  DeleteExpense_Classifiers.swift
//  SpareTests
//
//  Created by Matt Quiros on 06/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Bedrock
import CoreData
@testable import Spare

class DeleteExpense_Classifiers: CoreDataTestCase {
    
    func makeExpenses() {
        let rawExpenses = [
            RawExpense(amount: "200", dateSpent: Date(), category: "Food", tags: ["credit", "eat out"]),
            RawExpense(amount: "120", dateSpent: Date(), category: "Food", tags: ["coffee", "rewards card"]),
            RawExpense(amount: "149.99", dateSpent: Date(), category: "Food", tags: ["cash"]),
            RawExpense(amount: "88.94", dateSpent: Date(), category: "Transpo", tags: ["rideshare"]),
            RawExpense(amount: "15", dateSpent: Date(), category: "Transpo", tags: ["puv"]),
            RawExpense(amount: "8", dateSpent: Date(), category: "Transpo", tags: ["puv"]),
            RawExpense(amount: "1875", dateSpent: Date(), category: "Medicines", tags: ["fiber"])
        ]
        let validExpenses = rawExpenses.map({ makeValidExpense(from: $0) })
        for expense in validExpenses {
            let context = coreDataStack.newBackgroundContext()
            AddExpenseOperation(context: context, validExpense: expense, completionBlock: nil).start()
        }
    }
    
    func testCategory_noExpensesLeft_shouldNotBeDeleted() {
        makeExpenses()
        let expenseFetch: NSFetchRequest<Expense> = Expense.fetchRequest()
        expenseFetch.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(Expense.category.name), "Food")
        do {
            let expenses = try coreDataStack.viewContext.fetch(expenseFetch)
            XCTAssertTrue(expenses.count > 0)
            for expense in expenses {
                DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                       expenseId: expense.objectID,
                                       completionBlock: nil).start()
            }
            
            let categoryFetch: NSFetchRequest<Spare.Category> = Category.fetchRequest()
            categoryFetch.predicate = NSPredicate(format: "%K == %@",
                                                  #keyPath(Spare.Category.name), "Food")
            let category = try coreDataStack.viewContext.fetch(categoryFetch).first
            XCTAssertEqual(category?.expenses?.count, 0)
            XCTAssertNotNil(category)
        } catch {
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
    func testTags_noExpensesLeft_shouldNotBeDeleted() {
        makeExpenses()
        let expenseFetch: NSFetchRequest<Expense> = Expense.fetchRequest()
        expenseFetch.predicate = NSPredicate(format: "ANY tags.name == %@", "puv")
        do {
            let expenses = try coreDataStack.viewContext.fetch(expenseFetch)
            XCTAssertTrue(expenses.count > 0)
            for expense in expenses {
                DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                       expenseId: expense.objectID,
                                       completionBlock: nil).start()
            }
            let tagFetch: NSFetchRequest<Tag> = Tag.fetchRequest()
            tagFetch.predicate = NSPredicate(format: "%K == %@",
                                                  #keyPath(Tag.name), "puv")
            let tag = try coreDataStack.viewContext.fetch(tagFetch).first
            XCTAssertEqual(tag?.expenses?.count, 0)
            XCTAssertNotNil(tag)
        } catch {
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
}

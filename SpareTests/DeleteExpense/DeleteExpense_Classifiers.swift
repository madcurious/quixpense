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

class DeleteExpense_Classifiers: DeleteExpenseTestCase {
    
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

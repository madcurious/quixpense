//
//  DeleteExpense_DayCategoryGroup.swift
//  SpareTests
//
//  Created by Matt Quiros on 06/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Bedrock
import CoreData
@testable import Spare

class DeleteExpense_DayCategoryGroup: DeleteExpense_ClassifierGroups {
    
    func test_noExpensesLeftInGroup_shouldBeDeleted() {
        makeExpenses()
        let categoryName = "Food"
        let categoryFetch: NSFetchRequest<Spare.Category> = Category.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Spare.Category.name), categoryName)
        
        do {
            guard let category = try coreDataStack.viewContext.fetch(categoryFetch).first,
                let expenses = category.expenses as? Set<Expense>
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            
            /*
             All the dummy expenses are created within the same day, so they will
             have the same day category group. This test may fail if expenses
             were spent on non-same days.
             */
            var sectionId: String?
            for expense in expenses {
                if sectionId == nil {
                    sectionId = expense.dayCategoryGroup?.sectionIdentifier
                }
                
                DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                       expenseId: expense.objectID,
                                       completionBlock: nil).start()
            }
            
            let groupFetch: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
            groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                               #keyPath(DayCategoryGroup.sectionIdentifier), sectionId!,
                                               #keyPath(DayCategoryGroup.classifier), category)
            let matchingGroups = try coreDataStack.viewContext.fetch(groupFetch)
            XCTAssertTrue(matchingGroups.isEmpty)
        } catch {
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
    func test_someExpensesRemaining_totalShouldBeCorrect_countShouldBeCorrect() {
        makeExpenses()
        let categoryName = "Food"
        let categoryFetch: NSFetchRequest<Spare.Category> = Category.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Spare.Category.name), categoryName)
        
        do {
            guard let category = try coreDataStack.viewContext.fetch(categoryFetch).first,
                let randomExpense = category.expenses?.allObjects.first as? Expense,
                let group = randomExpense.dayCategoryGroup,
//                let sectionId = group.sectionIdentifier,
                let preDeleteCount = group.expenses?.count,
                let preDeleteTotal = group.total,
                let amountToBeDeducted = randomExpense.amount
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            
            // Delete the expense
            DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                   expenseId: randomExpense.objectID,
                                   completionBlock: nil).start()
            
//            let groupFetch: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
//            groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
//                                               #keyPath(DayCategoryGroup.sectionIdentifier), sectionId,
//                                               #keyPath(DayCategoryGroup.classifier), category)
//            if let sameGroup = try coreDataStack.viewContext.fetch(groupFetch).first {
//                XCTAssertEqual(sameGroup.expenses?.count, preDeleteCount - 1)
//                XCTAssertEqual(sameGroup.total, preDeleteTotal.subtracting(amountToBeDeducted))
//            } else {
//                XCTFail(BRTest.fail(#function, type: .nil))
//            }
            coreDataStack.viewContext.refreshAllObjects()
            XCTAssertEqual(group.expenses?.count, preDeleteCount - 1)
            XCTAssertEqual(group.total, preDeleteTotal.subtracting(amountToBeDeducted))
        } catch {
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
}

//
//  DeleteExpense_ClassifierGroups.swift
//  SpareTests
//
//  Created by Matt Quiros on 06/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare
import Bedrock

class DeleteExpense_ClassifierGroups: DeleteExpenseTestCase {
    
    func doTest_tagGroup_noExpensesRemaining_shouldBeDeleted(type: ClassifierGroup.Type, function: String) {
        makeExpenses()
        
        // Fetch the expense with the tag "coffee"
        let testExpenseFetch: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(Expense.amount), NSDecimalNumber(value: 120)),
            NSPredicate(format: "%K == %@", #keyPath(Expense.category.name), "Food"),
            NSPredicate(format: "ANY tags.name == %@", "coffee")
        ]
        testExpenseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let keyPath = tagGroupKeyPath(for: type)
            guard let testExpense = try coreDataStack.viewContext.fetch(testExpenseFetch).first,
                let groups = testExpense.value(forKey: keyPath) as? Set<ClassifierGroup>,
                let testGroup = groups.first(where : { $0.classifier?.name == "coffee" })
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            
            // Check that type is correct
            XCTAssertEqual(testGroup.entity.name, BRClassName(of: type))
            
            // There is only 1 expense with this tag, check that we got that right.
            XCTAssertEqual(testGroup.expenses?.count, 1)
            XCTAssertEqual(testGroup.total, 120)
            
            DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                   expenseId: testExpense.objectID,
                                   completionBlock: nil).start()
            
            coreDataStack.viewContext.refreshAllObjects()
            
            // Fetch a classifier group with the deleted classifier name
            let deletedGroupFetch: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: BRClassName(of: type))
            deletedGroupFetch.predicate = NSPredicate(format: "%K == %@",
                                                      #keyPath(ClassifierGroup.classifier.name),
                                                      "coffee")
            let results = try coreDataStack.viewContext.fetch(deletedGroupFetch)
            XCTAssertTrue(results.isEmpty)
        } catch {
            XCTFail(BRTest.fail(function, type: .error(error)))
        }
    }
    
    func doTest_tagGroup_expensesRemaining_totalAndCountShouldBeCorrect(type: ClassifierGroup.Type, function: String) {
        makeExpenses()
        
        // Fetch the Food expense with tag "credit"
        let testExpenseFetch: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(Expense.amount), NSDecimalNumber(value: 200)),
            NSPredicate(format: "%K == %@", #keyPath(Expense.category.name), "Food"),
            NSPredicate(format: "ANY tags.name == %@", "credit")
        ]
        testExpenseFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let keyPath = tagGroupKeyPath(for: type)
            guard let testExpense = try coreDataStack.viewContext.fetch(testExpenseFetch).first,
                let dayTagGroups = testExpense.value(forKey: keyPath) as? Set<ClassifierGroup>,
                let testGroup = dayTagGroups.first(where: { $0.classifier?.name == "credit" })
                else {
                    XCTFail(BRTest.fail(function, type: .nil))
                    return
            }
            
            // First, check that we have the correct type
            XCTAssertEqual(testGroup.entity.name, BRClassName(of: type))
            
            // There are 2 test expenses with this tag
            XCTAssertEqual(testGroup.expenses?.count, 2)
            XCTAssertEqual(testGroup.total, 288.94)
            
            DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                   expenseId: testExpense.objectID,
                                   completionBlock: nil).start()
            
            coreDataStack.viewContext.refreshAllObjects()
            XCTAssertEqual(testGroup.expenses?.count, 1)
            XCTAssertEqual(testGroup.total, 88.94)
        } catch {
            XCTFail(BRTest.fail(function, type: .error(error)))
        }
    }
    
}

// MARK: - Helper functions

extension DeleteExpense_ClassifierGroups {
    
    func tagGroupKeyPath(for type: ClassifierGroup.Type) -> String {
        switch type {
        case _ where type === DayTagGroup.self:
            return "dayTagGroups"
        case _ where type === WeekTagGroup.self:
            return "weekTagGroups"
        case _ where type === MonthTagGroup.self:
            return "monthTagGroups"
        default:
            fatalError("\(type) is not a Tag group.")
        }
    }
    
}

// MARK: - Tag groups

extension DeleteExpense_ClassifierGroups {
    
    func test_dayTagGroup_noExpensesRemaining_shouldBeDeleted() {
        doTest_tagGroup_noExpensesRemaining_shouldBeDeleted(type: DayTagGroup.self, function: #function)
    }
    
    func test_dayTagGroup_expensesRemaining_totalAndCountShouldBeCorrect() {
        doTest_tagGroup_expensesRemaining_totalAndCountShouldBeCorrect(type: DayTagGroup.self, function: #function)
    }
    
    func test_weekTagGroup_noExpensesRemaining_shouldBeDeleted() {
        doTest_tagGroup_noExpensesRemaining_shouldBeDeleted(type: WeekTagGroup.self, function: #function)
    }
    
    func test_weekTagGroup_expensesRemaining_totalAndCountShouldBeCorrect() {
        doTest_tagGroup_expensesRemaining_totalAndCountShouldBeCorrect(type: WeekTagGroup.self, function: #function)
    }
    
    func test_monthTagGroup_noExpensesRemaining_shouldBeDeleted() {
        doTest_tagGroup_noExpensesRemaining_shouldBeDeleted(type: MonthTagGroup.self, function: #function)
    }
    
    func test_monthTagGroup_expensesRemaining_totalAndCountShouldBeCorrect() {
        doTest_tagGroup_expensesRemaining_totalAndCountShouldBeCorrect(type: MonthTagGroup.self, function: #function)
    }
    
}

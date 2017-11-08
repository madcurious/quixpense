//
//  DeleteExpense_DayTagGroup.swift
//  SpareTests
//
//  Created by Matt Quiros on 08/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
import Bedrock
@testable import Spare

class DeleteExpense_DayTagGroup: DeleteExpense_ClassifierGroups {
    
    func test_noExpensesLeft_shouldBeDeleted() {
        makeExpenses()
        let tagName = "cash"
        let tagFetch: NSFetchRequest<Tag> = Tag.fetchRequest()
        tagFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Spare.Tag.name), tagName)
        do {
            guard let tag = try coreDataStack.viewContext.fetch(tagFetch).first,
                let expenses = tag.expenses as? Set<Expense>,
                let firstExpense = expenses.first,
                let groups = firstExpense.dayTagGroups as? Set<DayTagGroup>,
                let dayTagGroup = groups.first(where: { $0.classifier?.name == tagName }),
                let sectionId = dayTagGroup.sectionIdentifier
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            
            DeleteExpenseOperation(context: coreDataStack.newBackgroundContext(),
                                   expenseId: firstExpense.objectID,
                                   completionBlock: nil).start()
            
            let deletedGroupFetch: NSFetchRequest<DayTagGroup> = DayTagGroup.fetchRequest()
            deletedGroupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                                      #keyPath(DayTagGroup.sectionIdentifier), sectionId,
                                                      #keyPath(DayTagGroup.classifier.name), tagName)
            let matches = try coreDataStack.viewContext.fetch(deletedGroupFetch)
            XCTAssertTrue(matches.isEmpty)
        } catch {
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
}

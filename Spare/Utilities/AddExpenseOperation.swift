//
//  AddExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 20/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

enum AddExpenseOperationError: LocalizedError {
    case coreDataError(Error)
    
    var localizedDescription: String {
        switch self {
        case .coreDataError(let error):
            return "Database error occurred: \(error.localizedDescription)"
        }
    }
}

class AddExpenseOperation: TBAsynchronousOperation<Any, NSManagedObjectID, AddExpenseOperationError> {
    
    let context: NSManagedObjectContext
    let amount: NSDecimalNumber
    let dateSpent: Date
    let category: Category?
    let tags: Set<Tag>?
    
    init(amount: NSDecimalNumber,
                dateSpent: Date,
                category: Category?,
                tags: Set<Tag>?,
                completionBlock: @escaping TBOperationCompletionBlock) {
        self.context = Global.coreDataStack.newBackgroundContext()
        self.amount = amount
        self.dateSpent = dateSpent
        self.category = category
        self.tags = tags
        
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        defer {
            self.finish()
        }
        
        do {
            let newExpense = Expense(context: self.context)
            newExpense.dateCreated = Date()
            newExpense.amount = self.amount
            newExpense.dateSpent = self.dateSpent
            
            // Set the category.
            if let category = self.category {
                newExpense.category = category
            } else if let uncategorized = try DefaultClassifier.uncategorized.fetch(in: self.context) as? Category {
                newExpense.category = uncategorized
            }
            
            // Set the tags.
            if let tags = self.tags as NSSet? {
                newExpense.tags = tags
            } else if let untagged = try DefaultClassifier.untagged.fetch(in: self.context) as? Tag {
                newExpense.addToTags(untagged)
            }
            
            // Make the category groups.
            if let category = newExpense.category {
                let dayCategoryGroup = try self.makeGroup(with: category) as DayCategoryGroup
                newExpense.setValue(dayCategoryGroup, forKey: "dayCategoryGroup")
                
                let weekCategoryGroup = try self.makeGroup(with: category) as WeekCategoryGroup
                newExpense.setValue(weekCategoryGroup, forKey: "weekCategoryGroup")
                
                let monthCategoryGroup = try self.makeGroup(with: category) as MonthCategoryGroup
                newExpense.setValue(monthCategoryGroup, forKey: "monthCategoryGroup")
            }
            
            // Make the tag groups.
            if let tags = newExpense.tags as? Set<Tag> {
                for tag in tags {
                    let dayTagGroup = try self.makeGroup(with: tag) as DayTagGroup
                    newExpense.addToDayTagGroups(dayTagGroup)
                    
                    let weekTagGroup = try self.makeGroup(with: tag) as WeekTagGroup
                    newExpense.addToWeekTagGroups(weekTagGroup)
                    
                    let monthTagGroup = try self.makeGroup(with: tag) as MonthTagGroup
                    newExpense.addToMonthTagGroups(monthTagGroup)
                }
            }
            
            try self.context.saveToStore()
            self.result = .success(newExpense.objectID)
        } catch {
            self.result = .error(.coreDataError(error))
        }
    }
    
    private func makeGroup<T: NSManagedObject>(with classifier: NSManagedObject) throws -> T {
        let className = md_getClassName(T.self)
        let sectionIdentifier = self.makeSectionIdentifier(for: T.self)
        let groupFetch = NSFetchRequest<T>(entityName: className)
        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                           "sectionIdentifier", sectionIdentifier,
                                           "classifier", classifier
        )
        
        if let existingGroup = try self.context.fetch(groupFetch).first {
            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
            runningTotal += self.amount
            existingGroup.setValue(runningTotal, forKey: "total")
            return existingGroup
        } else {
            let newGroup = T(context: self.context)
            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
            newGroup.setValue(self.amount, forKey: "total")
            newGroup.setValue(classifier, forKey: "classifier")
            
            return newGroup
        }
    }
    
    private func makeSectionIdentifier(for type: AnyClass) -> String {
        let startDate: Date
        let endDate: Date
        
        if type === DayCategoryGroup.self || type === DayTagGroup.self {
            startDate = self.dateSpent.startOfDay()
            endDate = self.dateSpent.endOfDay()
        } else if type === WeekCategoryGroup.self || type === WeekTagGroup.self {
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = self.dateSpent.startOfWeek(firstWeekday: firstWeekday)
            endDate = self.dateSpent.endOfWeek(firstWeekday: firstWeekday)
        } else {
            startDate = self.dateSpent.startOfMonth()
            endDate = self.dateSpent.endOfMonth()
        }
        
        return SectionIdentifier.make(startDate: startDate, endDate: endDate)
    }
    
}

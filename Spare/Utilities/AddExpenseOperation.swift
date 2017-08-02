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

enum AddExpenseOperationError: LocalizedError, Equatable {
    case amountIsNotANumber
    case amountIsEmpty
    case amountIsZero
    case coreDataError(Error)
    
    var localizedDescription: String {
        switch self {
        case .amountIsEmpty:
            return "Amount can't be empty."
            
        case .amountIsNotANumber:
            return "Amount is an invalid number."
            
        case .amountIsZero:
            return "Amount can't be zero."
            
        case .coreDataError(let error):
            return "Database error occurred: \(error)"
        }
    }
    
    static func ==(lhs: AddExpenseOperationError, rhs: AddExpenseOperationError) -> Bool {
        switch (lhs, rhs) {
        case (.amountIsEmpty, .amountIsEmpty),
             (.amountIsNotANumber, .amountIsNotANumber),
             (.amountIsZero, .amountIsZero):
            return true
        case (.coreDataError(let error1), .coreDataError(let error2))
            where (error1 as NSError) == (error2 as NSError):
            return true
        default:
            return false
        }
    }
}

class AddExpenseOperation: TBOperation<NSManagedObjectID, AddExpenseOperationError> {
    
    private struct ValidEnteredData {
        let amount: NSDecimalNumber
        let date: Date
        let category: CategorySelection
        let tags: TagSelection
    }
    
    private enum ValidationResult {
        case success(ValidEnteredData)
        case error(AddExpenseOperationError)
    }
    
    let context: NSManagedObjectContext
    let enteredData: ExpenseFormViewController.EnteredData
    
    init(context: NSManagedObjectContext, enteredData: ExpenseFormViewController.EnteredData, completionBlock: TBOperationCompletionBlock?) {
        self.context = context
        self.enteredData = enteredData
        super.init(completionBlock: completionBlock)
    }
    
    private func validateEnteredData() -> ValidationResult {
        // Nil amount
        if enteredData.amount == nil {
            return .error(.amountIsEmpty)
        }
        
        // Empty strings
        guard let amount = enteredData.amount?.trim(),
            amount.isEmpty == false
            else {
                return .error(.amountIsEmpty)
        }
        
        // Non-numeric characters
        let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
        guard amount.rangeOfCharacter(from: invalidCharacterSet) == nil
            else {
            return .error(.amountIsNotANumber)
        }
        
        // Amount is just a period, no numbers
        guard amount.rangeOfCharacter(from: CharacterSet.wholeNumberCharacterSet()) != nil
            else {
                return .error(.amountIsNotANumber)
        }
        
        let amountNumber = NSDecimalNumber(string: amount)
        
        // NaN not allowed.
        if amountNumber.isEqual(to: NSDecimalNumber.notANumber) {
            return .error(.amountIsNotANumber)
        }
        
        // Zero not allowed.
        if amountNumber.isEqual(to: 0) {
            return .error(.amountIsZero)
        }
        
        let validData = ValidEnteredData(amount: amountNumber, date: enteredData.date, category: enteredData.category, tags: enteredData.tags)
        return .success(validData)
    }
    
    override func main() {
        do {
            let validEnteredData: ValidEnteredData
            switch validateEnteredData() {
            case .error(let error):
                result = .error(error)
                return
                    
            case .success(let validData):
                validEnteredData = validData
            }
            
            let newExpense = Expense(context: context)
            newExpense.dateCreated = Date()
            newExpense.amount = validEnteredData.amount
            newExpense.dateSpent = validEnteredData.date
            try setCategory(for: newExpense, from: validEnteredData.category)
            try setTags(for: newExpense, from: validEnteredData.tags)
            
            // Make the category groups.
            if let category = newExpense.category {
                let dayCategoryGroup = try makeGroup(with: category, using: validEnteredData) as DayCategoryGroup
                newExpense.setValue(dayCategoryGroup, forKey: "dayCategoryGroup")
                
                let weekCategoryGroup = try makeGroup(with: category, using: validEnteredData) as WeekCategoryGroup
                newExpense.setValue(weekCategoryGroup, forKey: "weekCategoryGroup")
                
                let monthCategoryGroup = try makeGroup(with: category, using: validEnteredData) as MonthCategoryGroup
                newExpense.setValue(monthCategoryGroup, forKey: "monthCategoryGroup")
            }
            
            // Make the tag groups.
            if let tags = newExpense.tags as? Set<Tag> {
                for tag in tags {
                    let dayTagGroup = try makeGroup(with: tag, using: validEnteredData) as DayTagGroup
                    newExpense.addToDayTagGroups(dayTagGroup)
                    
                    let weekTagGroup = try makeGroup(with: tag, using: validEnteredData) as WeekTagGroup
                    newExpense.addToWeekTagGroups(weekTagGroup)
                    
                    let monthTagGroup = try makeGroup(with: tag, using: validEnteredData) as MonthTagGroup
                    newExpense.addToMonthTagGroups(monthTagGroup)
                }
            }
            
            try self.context.saveToStore()
            self.result = .success(newExpense.objectID)
        } catch {
            result = .error(.coreDataError(error))
        }
    }
    
    private func setCategory(for expense: Expense, from selection: CategorySelection) throws {
        switch selection {
        case .id(let objectID):
            expense.category = context.object(with: objectID) as? Category
        case .name(let categoryName):
            // Check if the category name exists; if not, create it.
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
            if let existingCategory = try context.fetch(fetchRequest).first {
                expense.category = existingCategory
            } else {
                let newCategory = Category(context: context)
                newCategory.name = categoryName
                expense.category = newCategory
            }
        case .none:
            if let uncategorized = try DefaultClassifier.uncategorized.fetch(in: context) as? Category {
                expense.category = uncategorized
            } else {
                let uncategorized = Category(context: context)
                uncategorized.name = DefaultClassifier.uncategorized.rawValue
                expense.category = uncategorized
            }
        }
    }
    
    private func setTags(for expense: Expense, from selection: TagSelection) throws {
        // Set the tags.
        switch selection {
        // Add the members of the tag selection.
        case .list(let list) where list.isEmpty == false:
            for member in list {
                switch member {
                case .id(let objectID):
                    if let existingTag = context.object(with: objectID) as? Tag {
                        expense.addToTags(existingTag)
                    }
                case .name(let tagName):
                    // If the tag name exists, use it; if not, create it.
                    let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), tagName)
                    if let existingTag = try self.context.fetch(fetchRequest).first {
                        expense.addToTags(existingTag)
                    } else {
                        let newTag = Tag(context: context)
                        newTag.name = tagName
                        expense.addToTags(newTag)
                    }
                }
            }
            
        // Untagged
        default:
            if let untagged = try DefaultClassifier.untagged.fetch(in: context) as? Tag {
                expense.addToTags(untagged)
            } else {
                let untagged = Tag(context: context)
                untagged.name = DefaultClassifier.untagged.rawValue
                expense.addToTags(untagged)
            }
        }
    }
    
    private func makeGroup<T: NSManagedObject>(with classifier: NSManagedObject, using validEnteredData: ValidEnteredData) throws -> T {
        let className = md_getClassName(T.self)
        let sectionIdentifier = self.makeSectionIdentifier(for: T.self, basedOn: validEnteredData.date)
        let groupFetch = NSFetchRequest<T>(entityName: className)
        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                           "sectionIdentifier", sectionIdentifier,
                                           "classifier", classifier
        )
        
        if let existingGroup = try context.fetch(groupFetch).first {
            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
            runningTotal += validEnteredData.amount
            existingGroup.setValue(runningTotal, forKey: "total")
            return existingGroup
        } else {
            let newGroup = T(context: context)
            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
            newGroup.setValue(validEnteredData.amount, forKey: "total")
            newGroup.setValue(classifier, forKey: "classifier")
            
            return newGroup
        }
    }
    
    private func makeSectionIdentifier(for type: AnyClass, basedOn date: Date) -> String {
        let startDate: Date
        let endDate: Date
        
        if type === DayCategoryGroup.self || type === DayTagGroup.self {
            startDate = date.startOfDay()
            endDate = date.endOfDay()
        } else if type === WeekCategoryGroup.self || type === WeekTagGroup.self {
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = date.startOfWeek(firstWeekday: firstWeekday)
            endDate = date.endOfWeek(firstWeekday: firstWeekday)
        } else {
            startDate = date.startOfMonth()
            endDate = date.endOfMonth()
        }
        
        return SectionIdentifier.make(startDate: startDate, endDate: endDate)
    }
    
}

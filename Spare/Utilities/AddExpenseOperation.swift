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
            return "Database error occurred: \(error)"
        }
    }
    
}

/**
 Adds an operation to the persistent store.
 
 - Important: Though it is possible, do not run multiple add expense operations simultaneously.
 If any of the operations are adding a new category name to the persistent store, multiple categories
 of the same name will be added to the store. To add multiple expenses, run the add operations serially.
 */
class AddExpenseOperation: TBOperation<NSManagedObjectID, AddExpenseOperationError> {
    
    let context: NSManagedObjectContext
    let validExpense: ValidExpense
    
    init(context: NSManagedObjectContext, validExpense: ValidExpense, completionBlock: TBOperationCompletionBlock?) {
        self.context = context
        self.validExpense = validExpense
        super.init(completionBlock: completionBlock)
    }
    
    class func fetchExistingCategory(forSelection categorySelection: CategorySelection, in context: NSManagedObjectContext) -> Category? {
        switch categorySelection {
        case .existing(let objectId):
            return context.object(with: objectId) as? Category
        case .new(let categoryName):
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
            return try! context.fetch(fetchRequest).first
        case .uncategorized:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.uncategorized.name)
            return try! context.fetch(fetchRequest).first
        }
    }
    
    class func fetchExistingTag(forTagSelectionMember member: TagSelection.Member, in context: NSManagedObjectContext) -> Tag? {
        switch member {
        case .existing(let objectId):
            return context.object(with: objectId) as? Tag
        case .new(let tagName):
            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), tagName)
            return try! context.fetch(fetchRequest).first
        }
    }
    
    class func fetchExistingClassifierGroup<T: ClassifierGroup>(with classifier: Classifier, periodization: Periodization, referenceDate: Date, in context: NSManagedObjectContext) -> T? {
        let sectionIdentifier = SectionIdentifier.make(dateSpent: referenceDate, periodization: periodization)
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        fetchRequest.predicate = NSPredicate(format: "%K == #@", #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentifier)
        return try! context.fetch(fetchRequest).first
    }
    
//    private struct ValidEnteredData {
//        let amount: NSDecimalNumber
//        let date: Date
//        let category: CategorySelection
//        let tags: TagSelection
//    }
//
//    private enum ValidationResult {
//        case success(ValidEnteredData)
//        case error(AddExpenseOperationError)
//    }
//
//    let context: NSManagedObjectContext
//    let rawExpense: RawExpense
//
//    init(context: NSManagedObjectContext, rawExpense: RawExpense, completionBlock: TBOperationCompletionBlock?) {
//        self.context = context
//        self.rawExpense = rawExpense
//        super.init(completionBlock: completionBlock)
//    }
//
//    private func validateEnteredData() -> ValidationResult {
//        // Nil amount
//        if rawExpense.amount == nil {
//            return .error(.amountIsEmpty)
//        }
//
//        // Empty strings
//        guard let amount = rawExpense.amount?.trim(),
//            amount.isEmpty == false
//            else {
//                return .error(.amountIsEmpty)
//        }
//
//        // Non-numeric characters
//        let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
//        guard amount.rangeOfCharacter(from: invalidCharacterSet) == nil
//            else {
//            return .error(.amountIsNotANumber)
//        }
//
//        // Amount is just a period, no numbers
//        guard amount.rangeOfCharacter(from: CharacterSet.wholeNumberCharacterSet()) != nil
//            else {
//                return .error(.amountIsNotANumber)
//        }
//
//        let amountNumber = NSDecimalNumber(string: amount)
//
//        // NaN not allowed.
//        if amountNumber.isEqual(to: NSDecimalNumber.notANumber) {
//            return .error(.amountIsNotANumber)
//        }
//
//        // Zero not allowed.
//        if amountNumber.isEqual(to: 0) {
//            return .error(.amountIsZero)
//        }
//
//        let validData = ValidEnteredData(amount: amountNumber, date: rawExpense.dateSpent, category: rawExpense.categorySelection, tags: rawExpense.tagSelection)
//        return .success(validData)
//    }
//
//    override func main() {
//        do {
//            let validEnteredData: ValidEnteredData
//            switch validateEnteredData() {
//            case .error(let error):
//                result = .error(error)
//                return
//
//            case .success(let validData):
//                validEnteredData = validData
//            }
//
//            let newExpense = Expense(context: context)
//            newExpense.dateCreated = Date()
//            newExpense.amount = validEnteredData.amount
//            newExpense.dateSpent = validEnteredData.date
//            try setCategory(for: newExpense, from: validEnteredData.category)
//            try setTags(for: newExpense, from: validEnteredData.tags)
//
//            // Make the category groups.
//            if let category = newExpense.category {
//                let dayCategoryGroup = try makeGroup(with: category, using: validEnteredData) as DayCategoryGroup
//                newExpense.setValue(dayCategoryGroup, forKey: "dayCategoryGroup")
//
//                let weekCategoryGroup = try makeGroup(with: category, using: validEnteredData) as WeekCategoryGroup
//                newExpense.setValue(weekCategoryGroup, forKey: "weekCategoryGroup")
//
//                let monthCategoryGroup = try makeGroup(with: category, using: validEnteredData) as MonthCategoryGroup
//                newExpense.setValue(monthCategoryGroup, forKey: "monthCategoryGroup")
//            }
//
//            // Make the tag groups.
//            if let tags = newExpense.tags as? Set<Tag> {
//                for tag in tags {
//                    let dayTagGroup = try makeGroup(with: tag, using: validEnteredData) as DayTagGroup
//                    newExpense.addToDayTagGroups(dayTagGroup)
//
//                    let weekTagGroup = try makeGroup(with: tag, using: validEnteredData) as WeekTagGroup
//                    newExpense.addToWeekTagGroups(weekTagGroup)
//
//                    let monthTagGroup = try makeGroup(with: tag, using: validEnteredData) as MonthTagGroup
//                    newExpense.addToMonthTagGroups(monthTagGroup)
//                }
//            }
//
//            try self.context.saveToStore()
//            self.result = .success(newExpense.objectID)
//        } catch {
//            result = .error(.coreDataError(error))
//        }
//    }
//
//    private func setCategory(for expense: Expense, from selection: CategorySelection) throws {
//        switch selection {
//        case .id(let objectID):
//            expense.category = context.object(with: objectID) as? Category
//        case .name(let categoryName):
//            // Check if the category name exists; if not, create it.
//            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
//            if let existingCategory = try context.fetch(fetchRequest).first {
//                expense.category = existingCategory
//            } else {
//                let newCategory = Category(context: context)
//                newCategory.name = categoryName
//                expense.category = newCategory
//            }
//        case .none:
//            if let uncategorized = try DefaultClassifier.uncategorized.fetch(in: context) as? Category {
//                expense.category = uncategorized
//            } else {
//                let uncategorized = Category(context: context)
//                uncategorized.name = DefaultClassifier.uncategorized.name
//                expense.category = uncategorized
//            }
//        }
//    }
//
//    private func setTags(for expense: Expense, from selection: TagSelection) throws {
//        // Set the tags.
//        switch selection {
//        // Add the members of the tag selection.
//        case .list(let list) where list.isEmpty == false:
//            for member in list {
//                switch member {
//                case .id(let objectID):
//                    if let existingTag = context.object(with: objectID) as? Tag {
//                        expense.addToTags(existingTag)
//                    }
//                case .name(let tagName):
//                    // If the tag name exists, use it; if not, create it.
//                    let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
//                    fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), tagName)
//                    if let existingTag = try self.context.fetch(fetchRequest).first {
//                        expense.addToTags(existingTag)
//                    } else {
//                        let newTag = Tag(context: context)
//                        newTag.name = tagName
//                        expense.addToTags(newTag)
//                    }
//                }
//            }
//
//        // Untagged
//        default:
//            if let untagged = try DefaultClassifier.untagged.fetch(in: context) as? Tag {
//                expense.addToTags(untagged)
//            } else {
//                let untagged = Tag(context: context)
//                untagged.name = DefaultClassifier.untagged.name
//                expense.addToTags(untagged)
//            }
//        }
//    }
//
//    private func makeGroup<T: NSManagedObject>(with classifier: NSManagedObject, using validEnteredData: ValidEnteredData) throws -> T {
//        let className = md_getClassName(T.self)
//        let sectionIdentifier = self.makeSectionIdentifier(for: T.self, basedOn: validEnteredData.date)
//        let groupFetch = NSFetchRequest<T>(entityName: className)
//        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
//                                           "sectionIdentifier", sectionIdentifier,
//                                           "classifier", classifier
//        )
//
//        if let existingGroup = try context.fetch(groupFetch).first {
//            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
//            runningTotal += validEnteredData.amount
//            existingGroup.setValue(runningTotal, forKey: "total")
//            return existingGroup
//        } else {
//            let newGroup = T(context: context)
//            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
//            newGroup.setValue(validEnteredData.amount, forKey: "total")
//            newGroup.setValue(classifier, forKey: "classifier")
//
//            return newGroup
//        }
//    }
//
//    private func makeSectionIdentifier(for type: AnyClass, basedOn date: Date) -> String {
//        if type === DayCategoryGroup.self || type === DayTagGroup.self {
//            return SectionIdentifier.make(dateSpent: date, periodization: .day)
//        } else if type === WeekCategoryGroup.self || type === WeekTagGroup.self {
//            return SectionIdentifier.make(dateSpent: date, periodization: .week)
//        } else {
//            return SectionIdentifier.make(dateSpent: date, periodization: .month)
//        }
//    }
    
}

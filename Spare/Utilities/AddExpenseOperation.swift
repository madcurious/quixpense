//
//  AddExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 20/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

enum AddExpenseError: LocalizedError {
    
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
class AddExpenseOperation: BROperation<NSManagedObjectID, AddExpenseError> {
    
    let context: NSManagedObjectContext
    let validExpense: ValidExpense
    
    init(context: NSManagedObjectContext, validExpense: ValidExpense, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.validExpense = validExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        let expense = Expense(context: context)
        expense.amount = validExpense.amount
        expense.dateSpent = validExpense.dateSpent
        
        let category = AddExpenseOperation.category(forSelection: validExpense.categorySelection, in: context)
        expense.category = category
        
        if let dayCategoryGroup: DayCategoryGroup = fetchExistingClassifierGroup(with: category, date: validExpense.dateSpent) {
            dayCategoryGroup.total = dayCategoryGroup.total?.adding(validExpense.amount)
            expense.dayCategoryGroup = dayCategoryGroup
        } else {
            let newGroup: DayCategoryGroup = makeClassifierGroup(with: category, date: validExpense.dateSpent)
            newGroup.total = validExpense.amount
            expense.dayCategoryGroup = newGroup
        }
        
        do {
            try context.saveToStore()
            result = .success(expense.objectID)
        } catch {
            result = .error(.coreDataError(error))
        }
    }
    
    func derivePeriodization(from classifierGroupType: AnyClass) -> Periodization {
        switch classifierGroupType {
        case _ where classifierGroupType === DayCategoryGroup.self || classifierGroupType === DayTagGroup.self:
            return .day
        case _ where classifierGroupType === WeekCategoryGroup.self || classifierGroupType === WeekTagGroup.self:
            return .week
        default:
            return .month
        }
    }
    
    func makeClassifierGroup<T: ClassifierGroup>(with classifier: Classifier, date: Date) -> T {
        let periodization = derivePeriodization(from: T.self)
        let classifierGroup = T(context: context)
        classifierGroup.sectionIdentifier = SectionIdentifier.make(referenceDate: date, periodization: periodization)
        classifierGroup.classifier = classifier
        return classifierGroup
    }
    
    func fetchExistingClassifierGroup<T: ClassifierGroup>(with classifier: Classifier, date: Date) -> T? {
        let periodization = derivePeriodization(from: T.self)
        let sectionIdentifier = SectionIdentifier.make(referenceDate: date, periodization: periodization)
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentifier,
                                             #keyPath(ClassifierGroup.classifier), classifier
        )
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - Class functions
    
    /**
     Returns the `Category` that will be assigned to an `Expense` based on the `CategorySelection` indicated
     in the `ValidExpense`.
     */
    class func category(forSelection categorySelection: CategorySelection, in context: NSManagedObjectContext) -> Category {
        switch categorySelection {
        case .existing(let objectId):
            return context.object(with: objectId) as! Category
            
        case .new(let categoryName):
            if let existingCategory = AddExpenseOperation.fetchExistingCategory(named: categoryName, in: context) {
                return existingCategory
            } else {
                let category = Category(context: context)
                category.name = categoryName
                return category
            }
            
        case .none:
            return DefaultClassifier.noCategory.fetch(in: context)
        }
    }
    
    /**
     Returns a `Category` if the provided name already exists in the store. Returns `nil` otherwise.
     */
    class func fetchExistingCategory(named name: String, in context: NSManagedObjectContext) -> Category? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), name)
        return try! context.fetch(fetchRequest).first
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
    
}

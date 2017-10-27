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

/**
 Adds an operation to the persistent store.
 
 - Important: Though it is possible, do not run multiple add expense operations simultaneously.
 If any of the operations are adding a new category name to the persistent store, multiple categories
 of the same name will be added to the store. To add multiple expenses, run the add operations serially.
 */
class AddExpenseOperation: BROperation<NSManagedObjectID, Error> {
    
    let context: NSManagedObjectContext
    let validExpense: ValidExpense
    
    init(context: NSManagedObjectContext, validExpense: ValidExpense, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.validExpense = validExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        do {
            let expense = Expense(context: context)
            expense.dateCreated = Date()
            expense.amount = validExpense.amount
            expense.dateSpent = validExpense.dateSpent
            
            // Set category
            if let existingCategory = try AddExpenseOperation.fetchExistingClassifier(classifierType: .category, name: validExpense.category, context: context) {
                expense.setValue(existingCategory, forKey: #keyPath(Expense.category))
            } else {
                let newCategory = Category(context: context)
                newCategory.name = validExpense.category
                expense.category = newCategory
            }
            
            var tags = [NSManagedObject]()
            for tagName in validExpense.tags {
                if let existingTag = try AddExpenseOperation.fetchExistingClassifier(classifierType: .tag, name: tagName, context: context) {
                    tags.append(existingTag)
                } else {
                    let newTag = Tag(context: context)
                    newTag.name = tagName
                    tags.append(newTag)
                }
            }
            expense.tags = NSSet(array: tags)
            
            let categoryGroupKeyPaths: [(String, Periodization)] = [
                (#keyPath(Expense.dayCategoryGroup), .day),
                (#keyPath(Expense.weekCategoryGroup), .week),
                (#keyPath(Expense.monthCategoryGroup), .month)
            ]
            
            for (keyPath, periodization) in categoryGroupKeyPaths {
                if let existingGroup = try AddExpenseOperation.fetchExistingClassifierGroup(periodization: periodization, classifierType: .category, classifierName: validExpense.category, referenceDate: validExpense.dateSpent, context: context) {
                    
                    if let runningTotal = existingGroup.value(forKey: #keyPath(ClassifierGroup.total)) as? NSDecimalNumber {
                        existingGroup.setValue(runningTotal.adding(validExpense.amount), forKey: #keyPath(ClassifierGroup.total))
                    } else {
                        existingGroup.setValue(NSDecimalNumber.zero, forKey: #keyPath(ClassifierGroup.total))
                    }
                    
                    expense.setValue(existingGroup, forKey: keyPath)
                } else {
                    let entityDescription = AddExpenseOperation.classifierGroupEntityDescription(periodization: periodization, classifierType: .category, context: context)
                    let newGroup = NSManagedObject(entity: entityDescription, insertInto: context)
                    
                    let identifier = SectionIdentifier.make(referenceDate: validExpense.dateSpent, periodization: periodization)
                    newGroup.setValue(identifier, forKey: #keyPath(ClassifierGroup.sectionIdentifier))
                    newGroup.setValue(expense.category, forKey: #keyPath(ClassifierGroup.classifier))
                    newGroup.setValue(validExpense.amount, forKey: #keyPath(ClassifierGroup.total))
                    
                    expense.setValue(newGroup, forKey: keyPath)
                }
            }
            
            let tagGroupKeyPaths: [(String, Periodization)] = [
                (#keyPath(Expense.dayTagGroups), .day),
                (#keyPath(Expense.weekTagGroups), .week),
                (#keyPath(Expense.monthTagGroups), .month)
            ]
            
            for (keyPath, periodization) in tagGroupKeyPaths {
                var tagGroups = [NSManagedObject]()
                
                for tagName in validExpense.tags {
                    if let existingGroup = try AddExpenseOperation.fetchExistingClassifierGroup(periodization: periodization, classifierType: .tag, classifierName: tagName, referenceDate: validExpense.dateSpent, context: context) {
                        if let runningTotal = existingGroup.value(forKey: #keyPath(ClassifierGroup.total)) as? NSDecimalNumber {
                            existingGroup.setValue(runningTotal.adding(validExpense.amount), forKey: #keyPath(ClassifierGroup.total))
                        } else {
                            existingGroup.setValue(NSDecimalNumber.zero, forKey: #keyPath(ClassifierGroup.total))
                        }
                        expense.setValue(existingGroup, forKey: keyPath)
                    } else {
                        let entityDescription = AddExpenseOperation.classifierGroupEntityDescription(periodization: periodization, classifierType: .tag, context: context)
                        let identifier = SectionIdentifier.make(referenceDate: validExpense.dateSpent, periodization: periodization)
                        let tag = try AddExpenseOperation.fetchExistingClassifier(classifierType: .tag, name: tagName, context: context)
                        
                        let newGroup = NSManagedObject(entity: entityDescription, insertInto: context)
                        newGroup.setValue(identifier, forKey: #keyPath(ClassifierGroup.sectionIdentifier))
                        newGroup.setValue(tag, forKey: #keyPath(ClassifierGroup.classifier))
                        newGroup.setValue(validExpense.amount, forKey: #keyPath(ClassifierGroup.total))
                        tagGroups.append(newGroup)
                    }
                }
                
                expense.setValue(NSSet(array: tagGroups), forKey: keyPath)
            }
            
            try context.saveToStore()
            result = .success(expense.objectID)
        } catch {
            result = .error(error)
        }
    }
    
}

// MARK: - Class functions

extension AddExpenseOperation {
    
    class func fetchExistingClassifier(classifierType: ClassifierType, name: String, context: NSManagedObjectContext) throws -> NSManagedObject? {
        let entityDescription = classifierType == .category ? Category.entity() : Tag.entity()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityDescription.name!)
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(Classifier.name), name
        )
        return try context.fetch(fetchRequest).first
    }
    
    class func fetchExistingClassifierGroup(periodization: Periodization, classifierType: ClassifierType, classifierName: String, referenceDate: Date, context: NSManagedObjectContext) throws -> NSManagedObject? {
        let entityDescription = classifierGroupEntityDescription(periodization: periodization, classifierType: classifierType, context: context)
        let sectionIdentifier = SectionIdentifier.make(referenceDate: referenceDate, periodization: periodization)
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: entityDescription.name!)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentifier,
                                             #keyPath(ClassifierGroup.classifier.name), classifierName
        )
        return try context.fetch(fetchRequest).first
    }
    
    class func classifierGroupEntityDescription(periodization: Periodization, classifierType: ClassifierType, context: NSManagedObjectContext) -> NSEntityDescription {
        let classType: AnyClass = {
            switch (periodization, classifierType) {
            case (.day, .category):
                return DayCategoryGroup.self
            case (.week, .category):
                return WeekCategoryGroup.self
            case (.month, .category):
                return MonthCategoryGroup.self
            case (.day, .tag):
                return DayTagGroup.self
            case (.week, .tag):
                return WeekTagGroup.self
            case (.month, .tag):
                return MonthTagGroup.self
            }
        }()
        let className = BRClassName(of: classType)
        return NSEntityDescription.entity(forEntityName: className, in: context)!
    }
    
}

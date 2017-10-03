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
class AddExpenseOperation: TBOperation<NSManagedObjectID, AddExpenseError> {
    
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
        case .none:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.defaultCategoryName)
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
        let sectionIdentifier = SectionIdentifier.make(referenceDate: referenceDate, periodization: periodization)
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        fetchRequest.predicate = NSPredicate(format: "%K == #@", #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentifier)
        return try! context.fetch(fetchRequest).first
    }
    
}

//
//  ExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 13/12/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock
import CoreData

class ExpenseOperation<ResultType, ErrorType>: BROperation<ResultType, ErrorType> {
    
    let context: NSManagedObjectContext
    let details: ValidExpense
    
    init(context: NSManagedObjectContext, details: ValidExpense, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.details = details
        super.init(completionBlock: completionBlock)
    }
    
    /**
     Returns a classifier that is safe to work with. If it already exists in the object graph,
     the existing object is returned. Otherwise, a new object is created in the context and the
     new object is returned.
     */
    func safeClassifier(named name: String, type: ClassifierType) throws -> NSManagedObject {
        if let existing = try ObjectGraph.classifier(named: name, type: .category, in: context) as? Category {
            return existing
        }
        let new: Classifier = type == .category ? Category(context: context) : Tag(context: context)
        new.name = details.category
        return new
    }
    
    func safeClassifierGroup(ofType type: ClassifierGroupType, classifierName: String, referenceDate: Date) throws -> NSManagedObject {
        if let existing = try ObjectGraph.classifierGroup(ofType: type, classifierName: classifierName, referenceDate: referenceDate, in: context) {
            return existing
        }
        
        let new = NSManagedObject(entity: type.entityDescription, insertInto: context)
        
        let identifier = SectionIdentifier.make(referenceDate: referenceDate, periodization: type.periodization)
        new.setValue(identifier, forKey: #keyPath(ClassifierGroup.sectionIdentifier))
        
        let classifier = try safeClassifier(named: classifierName, type: type.classifierType)
        new.setValue(classifier, forKey: #keyPath(ClassifierGroup.classifier))
        
        new.setValue(NSDecimalNumber.zero, forKey: #keyPath(ClassifierGroup.total))
        return new
    }
    
    func safeCurrentTotal(ofClassifierGroup classifierGroup: NSManagedObject) -> NSDecimalNumber {
        // If the key path for the total exists, return it.
        if let runningTotal = classifierGroup.value(forKey: #keyPath(ClassifierGroup.total)) as? NSDecimalNumber {
            return runningTotal
        }
        
        // Otherwise, if there are expenses, recompute the total of the expenses.
        if let expenses = classifierGroup.value(forKey: "expenses") as? Set<Expense> {
            return expenses.flatMap({ $0.amount }).reduce(NSDecimalNumber(value: 0), { $0.adding($1) })
        }
        
        return NSDecimalNumber.zero
    }
    
    func safeNewTotal(ofClassifierGroup classifierGroup: NSManagedObject, afterRemoving amount: NSDecimalNumber) -> NSDecimalNumber {
        let currentTotal = safeCurrentTotal(ofClassifierGroup: classifierGroup)
        let newTotal = currentTotal.subtracting(amount)
        if newTotal.compare(NSDecimalNumber.zero) == .orderedDescending {
            return newTotal
        }
        return .zero
    }
    
}

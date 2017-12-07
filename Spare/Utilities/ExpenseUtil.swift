//
//  ExpenseUtil.swift
//  Spare
//
//  Created by Matt Quiros on 28/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

final class ExpenseUtil {
    
    class func setCategory(for expense: Expense, categoryName: String, in context: NSManagedObjectContext) throws -> Category {
        let category: Category = try {
            if let existing = try ObjectGraph.classifier(withName: categoryName, type: .category, in: context) as? Category {
                return existing
            }
            let newCategory = Category(context: context)
            newCategory.name = categoryName
            return newCategory
        }()
        expense.category = category
        
        return category
    }
    
    class func setCategoryGroups(for expense: Expense, category: Category, in context: NSManagedObjectContext) throws {
        for groupType in ClassifierType.category.groupTypes {
            // Update the category group.
            
            guard let categoryName = category.name,
                let amount = expense.amount,
                let dateSpent = expense.dateSpent
                else {
                    return
            }
            
            let categoryGroup: NSManagedObject = try {
                // Fetch an existing category group or make a new one.
                if let existing = try ObjectGraph.classifierGroup(withType: groupType, classifierName: categoryName, referenceDate: dateSpent, in: context) {
                    return existing
                }
                let newGroup = NSManagedObject(entity: groupType.entityDescription, insertInto: context)
                let identifier = SectionIdentifier.make(referenceDate: dateSpent, periodization: groupType.periodization)
                newGroup.setValue(identifier, forKey: #keyPath(ClassifierGroup.sectionIdentifier))
                newGroup.setValue(expense.category, forKey: #keyPath(ClassifierGroup.classifier))
                newGroup.setValue(amount, forKey: #keyPath(ClassifierGroup.total))
                return newGroup
            }()
            
            // Update the group's total.
            let newTotal = runningTotal(ofClassifierGroup: categoryGroup).adding(amount)
            categoryGroup.setValue(newTotal, forKey: #keyPath(ClassifierGroup.total))
            
            // Add the expense to the group.
            expense.setValue(categoryGroup, forKey: groupType.expenseKeyPath)
        }
    }
    
    class func remove(expense: Expense, fromClassifierGroup classifierGroup: ClassifierGroup) {
        classifierGroup.removeFromExpenses(expense)
        
        guard let amount = expense.amount
            else {
                return
        }
        let total = runningTotal(ofClassifierGroup: classifierGroup)
        if total.compare(NSDecimalNumber(value: 0)) == .orderedDescending { // if total > 0
            classifierGroup.total = total.subtracting(amount)
        }
    }
    
    /**
     Returns the running total of a classifier group. If the total is non-nil, it is simply returned.
     Otherwise, the total is recomputed from the expenses in the group.
     */
    class func runningTotal(ofClassifierGroup classifierGroup: NSManagedObject) -> NSDecimalNumber {
        // If the key path for the total exists, return it.
        if let runningTotal = classifierGroup.value(forKey: #keyPath(ClassifierGroup.total)) as? NSDecimalNumber {
            return runningTotal
        }

        // Otherwise, recompute the total of the expenses.
        let expenses = classifierGroup.value(forKey: "expenses") as! Set<Expense>
        return expenses.flatMap({ $0.amount }).reduce(NSDecimalNumber(value: 0), { $0.adding($1) })
    }
    
}

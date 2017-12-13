//
//  EditExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Bedrock

class EditExpenseOperation: ExpenseOperation<NSManagedObjectID, Error> {
    
    let expenseId: NSManagedObjectID
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, details: ValidExpense, completionBlock: BROperationCompletionBlock?) {
        self.expenseId = expenseId
        super.init(context: context, details: details, completionBlock: completionBlock)
    }
    
    override func main() {
        guard let expense = context.object(with: expenseId) as? Expense
            else {
                result = .error(BRError("The expense to edit no longer exists."))
                return
        }
        
        do {
            // Set the amount.
            expense.amount = details.amount
            
            // Set the date spent.
            expense.dateSpent = details.dateSpent
            
            // Check if the category is changed before modifying it.
            if let currentCategory = expense.category,
                currentCategory.name != details.category {
                
                // Remove the old category.
                currentCategory.removeFromExpenses(expense)
                
                // Set the new category.
                let category = try safeClassifier(named: details.category, type: .category)
                expense.setValue(category, forKey: #keyPath(Expense.category))
                
                // Begin updating category groups.
                for groupType in ClassifierType.category.groupTypes {
                    // Remove the expense from the old group.
                    if let oldGroup = expense.value(forKey: groupType.propertyKeyPath) as? ClassifierGroup {
                        oldGroup.removeFromExpenses(expense)
                        
                        // Remove the group if it no longer has expenses
                        if oldGroup.expenses == nil || oldGroup.expenses?.count == 0 {
                            context.delete(oldGroup)
                        } else {
                            // Otherwise, update the group's total.
                            let newTotal = safeNewTotal(ofClassifierGroup: oldGroup, afterRemoving: details.amount)
                            oldGroup.total = newTotal
                        }
                    }
                    
                    // Get a group of the same type.
                    let newGroup = try safeClassifierGroup(ofType: groupType, classifierName: details.category, referenceDate: details.dateSpent)
                    
                    // Add the amount to the group's total.
                    let total = safeCurrentTotal(ofClassifierGroup: newGroup).adding(details.amount)
                    newGroup.setValue(total.adding(details.amount), forKey: #keyPath(ClassifierGroup.total))
                    
                    // Add the group to the expense.
                    expense.setValue(newGroup, forKey: groupType.propertyKeyPath)
                }
            }
            
            // Begin updating the tags.
            if let tags = expense.tags as? Set<Classifier> {
                let currentTagNames = tags.flatMap({ $0.name })
                let tagsToRemove = currentTagNames.filter({ details.tags.contains($0) == false })
                let tagsToAdd = details.tags.filter({ currentTagNames.contains($0) == false })
                
                // Begin removing tags and tag groups, if any.
                if tagsToRemove.count > 0 {
                    for tagName in tagsToRemove {
                        // Remove the expense from the tag.
                        if let tagToRemove = tags.first(where: { $0.name == tagName }) {
                            tagToRemove.removeFromExpenses(expense)
                        }
                        
                        // Begin removing the expense from tag groups.
                        for groupType in ClassifierType.tag.groupTypes {
                            // Find an existing tag group with the tag name to remove.
                            if let tagGroups = expense.value(forKey: groupType.propertyKeyPath) as? Set<ClassifierGroup>,
                                let oldGroup = tagGroups.first(where: { $0.classifier?.name == tagName }) {
                                // Remove the expense from the group.
                                oldGroup.removeFromExpenses(expense)
                                // Remove the group if it no longer has expenses.
                                if oldGroup.expenses == nil || oldGroup.expenses?.count == 0 {
                                    context.delete(oldGroup)
                                } else {
                                    // Otherwise, update the group's total.
                                    let newTotal = safeNewTotal(ofClassifierGroup: oldGroup, afterRemoving: details.amount)
                                    oldGroup.total = newTotal
                                }
                            }
                        }
                    }
                }
                
                // Begin adding tags and tag groups, if any.
                if tagsToAdd.count > 0 {
                    for tagName in tagsToAdd {
                        // Add the tag.
                        let tag = try safeClassifier(named: tagName, type: .tag)
                        expense.addToTags(NSSet(objects: tag))
                        
                        // Begin adding tag groups.
                        for groupType in ClassifierType.tag.groupTypes {
                            guard let newGroup = try safeClassifierGroup(ofType: groupType, classifierName: tagName, referenceDate: details.dateSpent) as? ClassifierGroup
                                else {
                                    throw BRError("Unexpected error: Can't cast to 'ClassifierGroup'.")
                            }
                            
                            // Add the amount to the group's total.
                            let total = safeCurrentTotal(ofClassifierGroup: newGroup).adding(details.amount)
                            newGroup.total = total
                            
                            // Add the expense to the group.
                            newGroup.addToExpenses(expense)
                        }
                    }
                }
            }
        } catch {
            result = .error(error)
        }
    }
    
    
    
}



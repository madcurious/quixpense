//
//  EditExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

enum EditExpenseError: LocalizedError {
    
    case expenseNotFound
    case unexpected(Error)
    
    var errorDescription: String? {
        switch self {
        case .expenseNotFound:
            return "The expense to edit couldn't be found."
        case .unexpected(let error):
            return tb_errorMessage(from: error)
        }
    }
    
}

/**
 Edits an `Expense` with data from an already-validated, user-entered expense data.
 The operation does not accept the type `EnteredData` because doing so will require the execution
 of the validation operation anyway.
 */
class EditExpenseOperation: TBOperation<NSManagedObjectID, EditExpenseError> {
    
    let context: NSManagedObjectContext
    let expenseId: NSManagedObjectID
    let validExpense: ValidExpense
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, validExpense: ValidExpense, completionBlock: TBOperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        self.validExpense = validExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        guard let expense = fetchExpense()
            else {
                result = .error(.expenseNotFound)
                return
        }
        
        var shouldReplaceClassifierGroups = false
        
        expense.amount = validExpense.amount
        
        if shouldChangeDateSpent(expense.dateSpent, with: validExpense.dateSpent) {
            expense.dateSpent = validExpense.dateSpent
            shouldReplaceClassifierGroups = true
        }
        
        if shouldChangeCategory(expense.category, with: validExpense.categorySelection) {
            let newCategory = fetchOrMakeReplacementCategory(fromSelection: validExpense.categorySelection)
            expense.category = newCategory
            shouldReplaceClassifierGroups = true
        }
        
        if shouldReplaceClassifierGroups {
            let category = expense.category!
            
            // Replace the category groups
            let categoryGroups: [(String, Periodization)] = [
                (#keyPath(Expense.dayCategoryGroup), .day),
                (#keyPath(Expense.weekCategoryGroup), .week),
                (#keyPath(Expense.monthCategoryGroup), .month)
            ]
            
            for (keyPath, periodization) in categoryGroups {
                // Disassociate the current classifier group.
                if let currentGroup = expense.value(forKey: keyPath) as? ClassifierGroup {
                    currentGroup.removeFromExpenses(expense)
                    currentGroup.total = currentGroup.total?.subtracting(validExpense.amount)
                    
                    // Delete the classifier group if it contains no more expenses.
                    if currentGroup.expenses?.count == 0 {
                        context.delete(currentGroup)
                    }
                }
                
                if let newGroup = fetchReplacementClassifierGroup(periodization: periodization, classifier: category, dateSpent: validExpense.dateSpent) {
                    newGroup.total = newGroup.total?.adding(validExpense.amount)
                    newGroup.addToExpenses(expense)
                } else {
                    let newGroup = makeReplacementClassifierGroup(periodization: periodization, classifier: category, dateSpent: validExpense.dateSpent)
                    newGroup.addToExpenses(expense)
                }
            }
        }
        
        do {
            try context.saveToStore()
            result = .success(expenseId)
        } catch {
            result = .error(.unexpected(error))
        }
    }
    
}

extension EditExpenseOperation {
    
    func shouldChangeDateSpent(_ dateSpent: Date?, with newDateSpent: Date) -> Bool {
        return dateSpent != newDateSpent
    }
    
    func shouldChangeCategory(_ category: Category?, with categorySelection: CategorySelection) -> Bool {
        switch categorySelection {
        case .existing(let objectId):
            if category?.objectID == objectId {
                return false
            }
            return true
            
        case .new(let categoryName):
            if category?.name == categoryName {
                return false
            }
            return true
            
        case .none:
            if category?.name == DefaultClassifier.defaultCategoryName {
                return false
            }
            return true
        }
    }
    
}

// MARK: - Fetch functions
extension EditExpenseOperation {
    
    func fetchExpense() -> Expense? {
        return context.object(with: expenseId) as? Expense
    }
    
    func fetchOrMakeReplacementCategory(fromSelection categorySelection: CategorySelection) -> Category {
        switch categorySelection {
        case .existing(let objectId):
            return context.object(with: objectId) as! Category
            
        case .new(let categoryName):
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
            if let existingCategory = try! context.fetch(fetchRequest).first {
                return existingCategory
            } else {
                let newCategory = Category(context: context)
                newCategory.name = categoryName
                return newCategory
            }
            
        case .none:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.defaultCategoryName)
            return try! context.fetch(fetchRequest).first!
        }
    }
    
    func fetchReplacementClassifierGroup(periodization: Periodization, classifier: Classifier, dateSpent: Date) -> ClassifierGroup? {
        let sectionIdentififer = SectionIdentifier.make(referenceDate: dateSpent, periodization: periodization)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                    #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentififer,
                                    #keyPath(ClassifierGroup.classifier), classifier)
        
        switch (periodization) {
        case .day:
            if classifier is Category {
                let request: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            } else {
                let request: NSFetchRequest<DayTagGroup> = DayTagGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            }
            
        case .week:
            if classifier is Category {
                let request: NSFetchRequest<WeekCategoryGroup> = WeekCategoryGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            } else {
                let request: NSFetchRequest<WeekTagGroup> = WeekTagGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            }
            
        case .month:
            if classifier is Category {
                let request: NSFetchRequest<MonthCategoryGroup> = MonthCategoryGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            } else {
                let request: NSFetchRequest<MonthTagGroup> = MonthTagGroup.fetchRequest()
                request.predicate = predicate
                return (try? context.fetch(request))?.first
            }
        }
    }
    
    func makeReplacementClassifierGroup(periodization: Periodization, classifier: Classifier, dateSpent: Date) -> ClassifierGroup {
        let newClassifierGroup: ClassifierGroup = {
            switch periodization {
            case .day:
                return DayCategoryGroup(context: context)
            case .week:
                return WeekCategoryGroup(context: context)
            case .month:
                return MonthCategoryGroup(context: context)
            }
        }()
        newClassifierGroup.sectionIdentifier = SectionIdentifier.make(referenceDate: validExpense.dateSpent, periodization: periodization)
        newClassifierGroup.total = validExpense.amount
        newClassifierGroup.classifier = classifier
        return newClassifierGroup
    }
    
}


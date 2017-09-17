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
    let validEnteredExpense: ValidEnteredExpense
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, validEnteredExpense: ValidEnteredExpense, completionBlock: TBOperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        self.validEnteredExpense = validEnteredExpense
        super.init(completionBlock: completionBlock)
    }
    
    func fetchExpense() -> Expense? {
        return context.object(with: expenseId) as? Expense
    }
    
    override func main() {
        guard let expense = fetchExpense()
            else {
                result = .error(.expenseNotFound)
                return
        }
        
        expense.amount = validEnteredExpense.amount
        expense.dateSpent = validEnteredExpense.dateSpent
        
        if shouldChange(currentCategory: expense.category, from: validEnteredExpense.categorySelection) {
            let newCategory = category(fromSelection: validEnteredExpense.categorySelection)
            expense.category = newCategory
            
            let categoryGroups: [(String, Periodization)] = [
                (#keyPath(Expense.dayCategoryGroup), .day),
                (#keyPath(Expense.weekCategoryGroup), .week),
                (#keyPath(Expense.monthCategoryGroup), .month)
            ]
            for (keyPath, periodization) in categoryGroups {
                if let classifierGroup = expense.value(forKey: keyPath) as? ClassifierGroup {
                    classifierGroup.removeFromExpenses(expense)
                    classifierGroup.total = classifierGroup.total?.subtracting(validEnteredExpense.amount)
                }
                
                if let newClassifierGroup = fetchClassifierGroup(classifier: newCategory, dateSpent: validEnteredExpense.dateSpent, periodization: periodization) {
                    let currentTotal = newClassifierGroup.total ?? .zero
                    newClassifierGroup.total = currentTotal.adding(validEnteredExpense.amount)
                    newClassifierGroup.addToExpenses(expense)
                } else {
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
                    newClassifierGroup.sectionIdentifier = SectionIdentifier.make(dateSpent: validEnteredExpense.dateSpent, periodization: periodization)
                    newClassifierGroup.total = validEnteredExpense.amount
                    newClassifierGroup.classifier = newCategory
                    newClassifierGroup.addToExpenses(expense)
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
    
    func shouldChange(currentCategory: Category?, from categorySelection: CategorySelection) -> Bool {
        switch categorySelection {
        case .id(let objectId):
            if currentCategory?.objectID == objectId {
                return false
            }
            return true
            
        case .name(let categoryName):
            if currentCategory?.name == categoryName {
                return false
            }
            return true
            
        case .none:
            if currentCategory?.name == DefaultClassifier.uncategorized.name {
                return false
            }
            return true
        }
    }
    
    func category(fromSelection categorySelection: CategorySelection) -> Category {
        switch categorySelection {
        case .id(let objectId):
            return context.object(with: objectId) as! Category
            
        case .name(let categoryName):
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.uncategorized.name)
            if let existingCategory = try! context.fetch(fetchRequest).first {
                return existingCategory
            } else {
                let newCategory = Category(context: context)
                newCategory.name = categoryName
                return newCategory
            }
            
        case .none:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.uncategorized.name)
            return try! context.fetch(fetchRequest).first!
        }
    }
    
    func fetchClassifierGroup(classifier: Classifier, dateSpent: Date, periodization: Periodization) -> ClassifierGroup? {
        let sectionIdentififer = SectionIdentifier.make(dateSpent: dateSpent, periodization: periodization)
        let predicate = NSPredicate(format: "%K == %@",
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
    
}


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
    case validationError(ValidateEnteredExpenseError)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .expenseNotFound:
            return "The expense to edit couldn't be found."
        case .validationError(let validationError):
            return validationError.errorDescription
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
}

class EditExpenseOperation: TBOperation<Bool, EditExpenseError> {
    
    let context: NSManagedObjectContext
    let expenseId: NSManagedObjectID
    let enteredExpense: EnteredExpense
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, enteredExpense: EnteredExpense, completionBlock: TBOperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        self.enteredExpense = enteredExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        // First, validate the entered expense.
        let validationResult = validateEnteredExpense()
       
        switch validationResult {
        case .success(let validEnteredExpense):
            editExpense(from: validEnteredExpense)
        case .error(let error):
            result = .error(.validationError(error))
        case .none:
            result = .none
        }
    }
    
    func validateEnteredExpense() -> ValidateEnteredExpenseOperation.Result {
        let validateOperation = ValidateEnteredExpenseOperation(enteredExpense: enteredExpense, completionBlock: nil)
        validateOperation.start()
        return validateOperation.result
    }
    
    func editExpense(from validEnteredExpense: ValidEnteredExpense) {
        
    }
    
    func editExpense(validEnteredExpense: ValidEnteredExpense) throws {
        guard let expense = context.object(with: expenseId) as? Expense
            else {
                result = .error(.expenseNotFound)
                return
        }
        
        expense.amount = validEnteredExpense.amount
        expense.dateSpent = validEnteredExpense.date
        try updateCategory(for: expense, from: validEnteredExpense.categorySelection)
    }
    
    func updateCategory(for expense: Expense, from selection: CategorySelection) throws {
        let oldCategory = expense.category
        switch selection {
        case .id(let categoryId):
            // Do nothing if the category wasn't changed.
            if oldCategory?.objectID == categoryId {
                return
            }
            
            let existingCategory = context.object(with: categoryId) as? Category
            expense.category = existingCategory
            try updateCategoryGroups(for: expense)
            
        case .name(let categoryName):
            // Do nothing if the category wasn't changed.
            if oldCategory?.name == categoryName {
                return
            }
            
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), categoryName)
            let existingCategory = try context.fetch(fetchRequest).first
            expense.category = existingCategory
            try updateCategoryGroups(for: expense)
            
        case .none:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.uncategorized.name)
            let uncategorized = try context.fetch(fetchRequest).first
            expense.category = uncategorized
            try updateCategoryGroups(for: expense)
        }
    }
    
    func updateCategoryGroups(for expense: Expense) throws {
        guard let amount = expense.amount
            else {
                return
        }
        
        // 1. Remove the expense from its current groups and update the groups' totals.
        
        if let currentDayCategoryGroup = expense.dayCategoryGroup,
            let currentTotal = currentDayCategoryGroup.total {
            currentDayCategoryGroup.total = currentTotal.subtracting(amount)
            currentDayCategoryGroup.removeFromExpenses(expense)
        }
        
        if let currentWeekCategoryGroup = expense.weekCategoryGroup,
            let currentTotal = currentWeekCategoryGroup.total {
            currentWeekCategoryGroup.total = currentTotal.subtracting(amount)
            currentWeekCategoryGroup.removeFromExpenses(expense)
        }
        
        if let currentMonthCategoryGroup = expense.monthCategoryGroup,
            let currentTotal = currentMonthCategoryGroup.total {
            currentMonthCategoryGroup.total = currentTotal.subtracting(amount)
            currentMonthCategoryGroup.removeFromExpenses(expense)
        }
        
        // 2. Add the new groups and update the groups' totals.
        
        guard let dateSpent = expense.dateSpent,
            let category = expense.category
            else {
                return
        }
        
        if let dayGroup = try existingGroup(withClassifier: category, dateSpent: dateSpent, periodization: .day) as? DayCategoryGroup,
            let runningTotal = dayGroup.total {
            dayGroup.total = runningTotal.adding(amount)
            dayGroup.addToExpenses(expense)
        } else {
            let newGroup = DayCategoryGroup(context: context)
            newGroup.sectionIdentifier = SectionIdentifier.make(dateSpent: dateSpent, periodization: .day)
            newGroup.total = amount
            newGroup.classifier = category
            newGroup.addToExpenses(expense)
        }
        
        if let weekGroup = try existingGroup(withClassifier: category, dateSpent: dateSpent, periodization: .week) as? WeekCategoryGroup,
            let runningTotal = weekGroup.total {
            weekGroup.total = runningTotal.adding(amount)
            weekGroup.addToExpenses(expense)
        } else {
            let newGroup = WeekCategoryGroup(context: context)
            newGroup.sectionIdentifier = SectionIdentifier.make(dateSpent: dateSpent, periodization: .week)
            newGroup.total = amount
            newGroup.classifier = category
            newGroup.addToExpenses(expense)
        }
        
        if let monthGroup = try existingGroup(withClassifier: category, dateSpent: dateSpent, periodization: .month) as? MonthCategoryGroup,
            let runningTotal = monthGroup.total {
            monthGroup.total =  runningTotal.adding(amount)
            monthGroup.addToExpenses(expense)
        } else {
            let newGroup = MonthCategoryGroup(context: context)
            newGroup.sectionIdentifier = SectionIdentifier.make(dateSpent: dateSpent, periodization: .month)
            newGroup.total = amount
            newGroup.classifier = category
            newGroup.addToExpenses(expense)
        }
    }
    
    private func existingGroup<T: NSManagedObject>(withClassifier classifier: NSManagedObject, dateSpent: Date, periodization: Periodization) throws -> T? {
        let sectionIdentifier = SectionIdentifier.make(dateSpent: dateSpent, periodization: periodization)
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             "sectionIdentifier", sectionIdentifier,
                                             "classifier", classifier)
        let existingGroup = try context.fetch(fetchRequest).first
        return existingGroup
    }
    
}

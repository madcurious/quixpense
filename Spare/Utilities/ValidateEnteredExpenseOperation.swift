//
//  ValidateEnteredExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

enum ValidateEnteredExpenseError: LocalizedError {
    
    case amountIsEmpty
    case amountIsNotANumber
    case amountIsZero
    case unexpected(Error)
    
    var errorDescription: String? {
        switch self {
        case .amountIsEmpty:
            return "Amount can't be empty."
        case .amountIsNotANumber:
            return "Amount is not a valid number."
        case .amountIsZero:
            return "Amount can't be zero."
        case .unexpected(let error):
            return tb_errorMessage(from: error)
        }
    }
    
}

class ValidateEnteredExpenseOperation: TBOperation<ValidEnteredExpense, ValidateEnteredExpenseError> {
    
    let enteredExpense: EnteredExpense
    let context: NSManagedObjectContext
    
    init(enteredExpense: EnteredExpense, context: NSManagedObjectContext, completionBlock: TBOperationCompletionBlock?) {
        self.enteredExpense = enteredExpense
        self.context = context
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        // Nil amount
        if enteredExpense.amount == nil {
            result = .error(.amountIsEmpty)
            return
        }
        
        // Empty strings
        guard let amount = enteredExpense.amount?.trim(),
            amount.isEmpty == false
            else {
                result = .error(.amountIsEmpty)
                return
        }
        
        // Non-numeric characters
        let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
        guard amount.rangeOfCharacter(from: invalidCharacterSet) == nil
            else {
                result = .error(.amountIsNotANumber)
                return
        }
        
        // Amount is just a period, no numbers
        guard amount.rangeOfCharacter(from: CharacterSet.wholeNumberCharacterSet()) != nil
            else {
                result = .error(.amountIsNotANumber)
                return
        }
        
        let amountNumber = NSDecimalNumber(string: amount)
        
        // NaN not allowed.
        if amountNumber.isEqual(to: NSDecimalNumber.notANumber) {
            result = .error(.amountIsNotANumber)
            return
        }
        
        // Zero not allowed.
        if amountNumber.isEqual(to: 0) {
            result = .error(.amountIsZero)
            return
        }
        
        let validExpense = ValidEnteredExpense(amount: amountNumber, date: enteredExpense.date, categorySelection: enteredExpense.categorySelection, tagSelection: enteredExpense.tagSelection)
        result = .success(validExpense)
    }
    
}

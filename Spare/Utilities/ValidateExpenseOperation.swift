//
//  ValidateExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

enum ValidateExpenseError: LocalizedError {
    
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

class ValidateExpenseOperation: BROperation<ValidExpense, ValidateExpenseError> {
    
    let rawExpense: RawExpense
    let context: NSManagedObjectContext
    
    /**
     Creates a new operation.
     - parameters:
         - rawExpense: The struct holding the raw values entered by the user.
         - context: The context where categories and tags will be fetched from to check if they already exist.
     */
    init(rawExpense: RawExpense, context: NSManagedObjectContext, completionBlock: BROperationCompletionBlock?) {
        self.rawExpense = rawExpense
        self.context = context
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        // Nil amount
        if rawExpense.amount == nil {
            result = .error(.amountIsEmpty)
            return
        }
        
        // Empty strings
        guard let amount = rawExpense.amount?.trim(),
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
        
        let validExpense = ValidExpense(amount: amountNumber, dateSpent: rawExpense.dateSpent, categorySelection: rawExpense.categorySelection, tagSelection: rawExpense.tagSelection)
        result = .success(validExpense)
    }
    
}

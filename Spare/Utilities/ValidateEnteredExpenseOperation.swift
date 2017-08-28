//
//  ValidateEnteredExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

class ValidateEnteredExpenseOperation: TBOperation<ValidEnteredExpense, TBError> {
    
    let enteredExpense: EnteredExpense
    
    init(enteredExpense: EnteredExpense, completionBlock: TBOperationCompletionBlock?) {
        self.enteredExpense = enteredExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        // Nil amount
        if enteredExpense.amount == nil {
            result = .error(TBError("Amount can't be empty."))
            return
        }
        
        // Empty strings
        guard let amount = enteredExpense.amount?.trim(),
            amount.isEmpty == false
            else {
                result = .error(TBError("Amount can't be empty."))
                return
        }
        
        // Non-numeric characters
        let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
        guard amount.rangeOfCharacter(from: invalidCharacterSet) == nil
            else {
                result = .error(TBError("The entered amount is not a number."))
                return
        }
        
        // Amount is just a period, no numbers
        guard amount.rangeOfCharacter(from: CharacterSet.wholeNumberCharacterSet()) != nil
            else {
                result = .error(TBError("The entered amount is not a number."))
                return
        }
        
        let amountNumber = NSDecimalNumber(string: amount)
        
        // NaN not allowed.
        if amountNumber.isEqual(to: NSDecimalNumber.notANumber) {
            result = .error(TBError("The entered amount is not a number."))
            return
        }
        
        // Zero not allowed.
        if amountNumber.isEqual(to: 0) {
            result = .error(TBError("Amount can't be zero."))
            return
        }
        
        let validExpense = ValidEnteredExpense(amount: amountNumber, date: enteredExpense.date, categorySelection: enteredExpense.categorySelection, tagSelection: enteredExpense.tagSelection)
        result = .success(validExpense)
    }
    
}

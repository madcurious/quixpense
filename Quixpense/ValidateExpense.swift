//
//  ValidateExpense.swift
//  Quixpense
//
//  Created by Matt Quiros on 15/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock

class ValidateExpense: BROperation<ValidExpense, Error> {
    
    let rawExpense: RawExpense
    
    init(rawExpense: RawExpense, completionBlock: BROperationCompletionBlock?) {
        self.rawExpense = rawExpense
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        if rawExpense.amount == nil {
            result = .error(BRError("Amount can't be empty."))
            return
        }
        
        // Empty strings
        guard let amount = rawExpense.amount?.trim(),
            amount.isEmpty == false
            else {
                result = .error(BRError("Amount can't be empty."))
                return
        }
        
        // Non-numeric characters
        let invalidCharacterSet = CharacterSet.decimalNumberCharacterSet().inverted
        guard amount.rangeOfCharacter(from: invalidCharacterSet) == nil
            else {
                result = .error(BRError("Amount is not a number."))
                return
        }
        
        // Amount is just a period, no numbers
        guard amount.rangeOfCharacter(from: CharacterSet.wholeNumberCharacterSet()) != nil
            else {
                result = .error(BRError("Amount is not a number."))
                return
        }
        
        let amountNumber = NSDecimalNumber(string: amount)
        
        // NaN not allowed.
        if amountNumber.isEqual(to: NSDecimalNumber.notANumber) {
            result = .error(BRError("Amount is not a number."))
            return
        }
        
        // Zero not allowed.
        if amountNumber.isEqual(to: 0) {
            result = .error(BRError("Amount can't be zero."))
            return
        }
        
        let category = rawExpense.category ?? Classifier.category.default
        let tags: [String] = {
            if let tags = rawExpense.tags?.filter({ $0.trim().isEmpty == false }),
                tags.isEmpty == false {
                return tags
            }
            return [Classifier.tag.default]
        }()
        let validExpense = ValidExpense(amount: amountNumber,
                                        dateSpent: rawExpense.dateSpent,
                                        category: category,
                                        tags: tags)
        result = .success(validExpense)
    }
    
}

//
//  ValidateExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 19/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

enum ValidateExpenseOperationError: LocalizedError {
    case emptyAmount
    case zeroAmount
    
    var localizedDescription: String {
        switch self {
        case .emptyAmount:
            return "Amount can't be empty."
            
        case .zeroAmount:
            return "Amount can't be zero."
        }
    }
}

class ValidateExpenseOperation: TBAsynchronousOperation<Any, Bool, ValidateExpenseOperationError> {
    var amountText: String?
    
    init(amountText: String?, completionBlock: @escaping TBOperationCompletionBlock) {
        self.amountText = amountText
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        if self.amountText == nil {
            self.error = .emptyAmount
        }
        
        if let amountText = self.amountText,
            amountText.trim().isEmpty {
            self.error = .emptyAmount
        }
        
        if NSDecimalNumber(string: self.amountText).isEqual(to: 0) {
            self.error = .zeroAmount
        }
        
        self.result = true
        
        self.finish()
    }
    
}

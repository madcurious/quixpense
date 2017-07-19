//
//  ValidateExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 19/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

class ValidateExpenseOperation: MDAsynchronousOperation<Bool> {
    
    enum Error: LocalizedError {
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
    
    var amountText: String?
    
    init(amountText: String?) {
        self.amountText = amountText
    }
    
    override func makeResult(from source: Any?) throws -> Bool {
        if self.amountText == nil {
            throw ValidateExpenseOperation.Error.emptyAmount
        }
        
        if let amountText = self.amountText,
            amountText.trim().isEmpty {
            throw ValidateExpenseOperation.Error.emptyAmount
        }
        
        if NSDecimalNumber(string: self.amountText).isEqual(to: 0) {
            throw ValidateExpenseOperation.Error.zeroAmount
        }
        
        return true
    }
    
    override func main() {
        do {
            self.successBlock?(try self.makeResult(from: nil))
        } catch {
            self.failureBlock?(error)
        }
    }
    
}

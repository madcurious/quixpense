//
//  AddExpense_Amount.swift
//  SpareTests
//
//  Created by Matt Quiros on 29/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class AddExpense_Amount: CoreDataTestCase {
    
    func validEnteredExpense(from enteredExpense: EnteredExpense) -> ValidEnteredExpense {
        let validateOp = ValidateEnteredExpenseOperation(enteredExpense: enteredExpense, context: coreDataStack.viewContext, completionBlock: nil)
        validateOp.start()
        if case .success(let validExpense) = validateOp.result {
            return validExpense
        }
        fatalError()
    }
    
//    func testAmount_amountIsValid_shouldSucceed() {
//        let validExpense = validEnteredExpense(from: EnteredExpense(amount: "250.00", dateSpent: Date(), categorySelection: .name("Food"), tagSelection: .none))
//        let addOp = AddExpenseOperation(context: coreDataStack, enteredExpense: <#T##EnteredExpense#>, completionBlock: <#T##((TBOperation<NSManagedObjectID, AddExpenseOperationError>.Result) -> Void)?##((TBOperation<NSManagedObjectID, AddExpenseOperationError>.Result) -> Void)?##(TBOperation<NSManagedObjectID, AddExpenseOperationError>.Result) -> Void#>)
//    }
    
}

//
//  TestAddExpenseOperationAmount.swift
//  SpareTests
//
//  Created by Matt Quiros on 31/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
@testable import Spare

class TestAddExpenseOperationAmount: CoreDataTestCase {
    
    func testAmountString(_ amountString: String?, expectedError: AddExpenseOperationError?) {
        let xp = expectation(description: #function)
        let enteredData = ExpenseFormViewController.EnteredData(amount: amountString, date: Date(), category: .none, tags: .none)
        let addOp = AddExpenseOperation(context: coreDataStack.newBackgroundContext(), enteredData: enteredData) { (result) in
            let error: AddExpenseOperationError? = {
                switch result {
                case .error(let error):
                    return error
                default:
                    return nil
                }
            }()
            XCTAssertNotNil(error, "Error must not be nil.")
            
            if let error = error,
                let expectedError = expectedError {
                XCTAssertTrue(error == expectedError, "Error is \(error), not expected error \(expectedError)")
            }
            xp.fulfill()
        }
        
        operationQueue.addOperation(addOp)
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testNilAmount() {
        testAmountString(nil, expectedError: .amountIsEmpty)
    }
    
    func testEmptyStringAmount() {
        testAmountString("", expectedError: .amountIsEmpty)
    }
    
    func testZeroAmount() {
        testAmountString("0", expectedError: .amountIsZero)
    }
    
    func testPeriodAmount() {
        testAmountString(".", expectedError: .amountIsNotANumber)
    }
    
    func testInvalidCharacterAmount() {
        testAmountString("1gHf😂/+=`$", expectedError: .amountIsNotANumber)
    }
    
}

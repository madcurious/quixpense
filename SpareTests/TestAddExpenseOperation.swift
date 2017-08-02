//
//  TestAddExpenseOperation.swift
//  SpareTests
//
//  Created by Matt Quiros on 31/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class TestAddExpenseOperation: XCTestCase {
    
    var coreDataStack: NSPersistentContainer?
    var operationQueue: OperationQueue?
    
    override func setUp() {
        super.setUp()
        
        let queue = OperationQueue()
        operationQueue = queue
        
        let xp = expectation(description: "\(#function)\(#line)")
        let loadOp = LoadCoreDataStackOperation(inMemory: true) {[unowned self] result in
            switch result {
            case .success(let container):
                self.coreDataStack = container
            default:
                break
            }
            xp.fulfill()
        }
        
        queue.addOperation(loadOp)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    override func tearDown() {
        coreDataStack = nil
        operationQueue = nil
    }
    
    func testAmountString(_ amountString: String?, expectedError: AddExpenseOperationError?) {
        guard let queue = operationQueue,
            let stack = coreDataStack
            else {
                XCTAssertNotNil(operationQueue)
                XCTAssertNotNil(coreDataStack)
                return
        }
        
        let xp = expectation(description: #function)
        
        let enteredData = ExpenseFormViewController.EnteredData(amount: amountString, date: Date(), category: .none, tags: .none)
        let addOp = AddExpenseOperation(context: stack.newBackgroundContext(), enteredData: enteredData) { (result) in
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
        
        queue.addOperation(addOp)
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

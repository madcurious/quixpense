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
    
//    override func setUp() {
//        let loadOp = LoadCoreDataStackOperation(inMemory: true) {[unowned self] result in
//            switch result {
//            case .success(let container):
//                self.coreDataStack = container
//            default:
//                break
//            }
//        }
//        operationQueue.addOperations([loadOp], waitUntilFinished: true)
//    }
//
//    override func tearDown() {
//        coreDataStack = nil
//    }
    
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
    
    func testEmptyAmount() {
        guard let queue = operationQueue,
            let stack = coreDataStack
            else {
                XCTAssertNotNil(operationQueue)
                XCTAssertNotNil(coreDataStack)
                return
        }
        
        let xp = expectation(description: #function)
        
        let enteredData = ExpenseFormViewController.EnteredData(amount: nil, date: Date(), category: .none, tags: .none)
        let addOp = AddExpenseOperation(context: stack.newBackgroundContext(), enteredData: enteredData) { (result) in
            let error: Error? = {
                switch result {
                case .error(let error):
                    return error
                default:
                    return nil
                }
            }()
            XCTAssertNotNil(error, "Error found: \(error?.localizedDescription)")
            
            if case .success(let objectID) = result {
                XCTAssertNil(objectID, "Expense with objectID \(objectID) added successfully when it should have failed.")
            }
            
            if case .none = result {
                XCTAssertFalse(true, "Result is none.")
            }
            
            xp.fulfill()
        }
        
        queue.addOperation(addOp)
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}

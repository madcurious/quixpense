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
    
    var coreDataStack: NSPersistentContainer!
    let operationQueue = OperationQueue()
    
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
    
    func testEmptyAmount() {
        let xp = expectation(description: #function)
        
        let input = ExpenseFormViewController.InputModel(amountText: nil, selectedDate: Date(), selectedCategory: .none, selectedTags: .none)
        let addOp = AddExpenseOperation(context: coreDataStack.newBackgroundContext(), inputModel: input) { (result) in
            let error: Error? = {
                switch result {
                case .error(let error):
                    return error
                default:
                    return nil
                }
            }()
            XCTAssertNotNil(error)
            xp.fulfill()
        }
        
        operationQueue.addOperation(addOp)
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}

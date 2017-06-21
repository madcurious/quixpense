//
//  MakeExpenseOperationTest.swift
//  SpareTests
//
//  Created by Matt Quiros on 21/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Spare

let kTimeOut = 10.0

class MakeExpenseOperationTest: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    let queue = OperationQueue()
    
    override func setUp() {
        super.setUp()
        let expectation = self.expectation(description: #function)
        
        let op = InitializeCoreDataStackOperation(inMemory: true)
        op.successBlock = {[unowned self] in
            self.coreDataStack = CoreDataStack(persistentContainer: $0)
        }
        op.completionBlock = {
            expectation.fulfill()
        }
        queue.addOperation(op)
        
        self.waitForExpectations(timeout: kTimeOut, handler: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        self.coreDataStack = nil
    }
    
    func testUncategorized() {
        let expectation = self.expectation(description: #function)
        
        let context = self.coreDataStack.newBackgroundContext()
        let currentDate = Date()
        let op = MakeExpenseOperation(context: context,
                                      amount: 150,
                                      dateSpent: currentDate,
                                      categoryName: nil,
                                      tagNames: ["cash", "coffee"])
        op.completionBlock = {
            XCTAssertNotNil(op.result)
            XCTAssertEqual(op.result!.category!.name, "Uncategorized")
            expectation.fulfill()
        }
        op.start()
        
        self.waitForExpectations(timeout: kTimeOut, handler: nil)
    }
    
}

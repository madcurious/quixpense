//
//  InitializeCoreDataStackTest.swift
//  SpareTests
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData

class InitializeCoreDataStackTest: XCTestCase {
    
    var operationQueue: OperationQueue!
    
    override func setUp() {
        super.setUp()
        self.operationQueue = OperationQueue()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializeSuccess() {
        let expectation = self.expectation(description: #function)
        
        let op = InitializeCoreDataStackOperation(dataModelName: "Spare", inMemory: true)
        
        XCTAssertTrue(op.inMemory)
        
        op.completionBlock = {
            XCTAssertNil(op.result)
            
            let persistentStoreType = op.result!.persistentStoreDescriptions.first!.type
            XCTAssertEqual(persistentStoreType, NSInMemoryStoreType)
            
            expectation.fulfill()
        }
        
        self.operationQueue.addOperation(op)
        
        self.waitForExpectations(timeout: 30, handler: { _ in
            op.cancel()
        })
    }
    
//    func testInitializeFail() {
//        let op = InitializeCoreDataStackOperation(dataModelName: "InvalidDataModelName", inMemory: true)
//        op.completionBlock = {
//            XCTAssertNotNil(op.error)
//        }
//
//        op.start()
//    }
    
}









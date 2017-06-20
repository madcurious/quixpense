//
//  CoreDataStackTest.swift
//  SpareTests
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData

class CoreDataStackTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializeSuccess() {
        let op = InitializeCoreDataStackOperation(dataModelName: "Spare", inMemory: true)
        
        XCTAssertTrue(op.inMemory)
        
        op.completionBlock = {
            XCTAssertNotNil(op.result)
            
            let persistentStoreType = op.result!.persistentStoreDescriptions.first!.type
            XCTAssertEqual(persistentStoreType, NSInMemoryStoreType)
        }
        
        op.start()
    }
    
    func testInitializeFail() {
        let op = InitializeCoreDataStackOperation(dataModelName: "InvalidDataModelName", inMemory: true)
        op.completionBlock = {
            XCTAssertNotNil(op.error)
        }
        
        op.start()
    }
    
}









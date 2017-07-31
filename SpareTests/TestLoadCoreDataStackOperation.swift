//
//  TestLoadCoreDataStackOperation.swift
//  SpareTests
//
//  Created by Matt Quiros on 31/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class TestCoreDataStackOperation: XCTestCase {
    
    let queue = OperationQueue()
    
    func testLoadOperation() {
        let xp = expectation(description: #function)
        let loadOp = LoadCoreDataStackOperation(inMemory: true) { (result) in
            switch result {
            case .success(let container):
                XCTAssertTrue(container.persistentStoreDescriptions.first != nil)
                
                if let persistentStoreDescription = container.persistentStoreDescriptions.first {
                    XCTAssertTrue(persistentStoreDescription.type == NSInMemoryStoreType)
                }
                
                if let mergedModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) {
                    XCTAssertEqual(container.managedObjectModel, mergedModel)
                }
                
            default:
                XCTFail()
            }
            xp.fulfill()
        }
        queue.addOperation(loadOp)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testManualOperation() {
        let xp = expectation(description: #function)
        let container = NSPersistentContainer(name: "Spare")
        
        if let description = container.persistentStoreDescriptions.first {
            description.type = NSInMemoryStoreType
            print("\(#function) - setting in memory type")
        } else {
            print("\(#function) - did not set memory type")
        }
        
        container.loadPersistentStores { (_, error) in
            xp.fulfill()
            XCTAssertNil(error)
            if let persistentStoreDescription = container.persistentStoreDescriptions.first {
                XCTAssertTrue(persistentStoreDescription.type == NSInMemoryStoreType)
            }
            
            if let mergedModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) {
                XCTAssertEqual(container.managedObjectModel, mergedModel)
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
}

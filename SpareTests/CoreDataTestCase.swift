//
//  CoreDataTestCase.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
@testable import Spare

class CoreDataTestCase: XCTestCase {
    
    var coreDataStack: NSPersistentContainer?
    var operationQueue = OperationQueue()
    
    override func setUp() {
        super.setUp()
        
        operationQueue = OperationQueue()
        
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
        
        operationQueue.addOperation(loadOp)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    override func tearDown() {
        coreDataStack = nil
    }
    
}

//
//  CoreDataTest.swift
//  QuixpenseTests
//
//  Created by Matt Quiros on 15/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import XCTest
import CoreData
import Bedrock

class CoreDataTest: XCTestCase {
    
    var container: NSPersistentContainer!
    var queue = OperationQueue()
    
    var setupTimeout = TimeInterval(60)
    
    override func setUp() {
        super.setUp()
        
        queue = OperationQueue()
        
        let xp = expectation(description: "\(#function)\(#line)")
        loadCoreDataStack {
            xp.fulfill()
        }
        wait(for: [xp], timeout: setupTimeout)
    }
    
    func loadCoreDataStack(completion: (() -> Void)?) {
        let xp = expectation(description: #function)
        let loadOp = BRLoadPersistentContainer(documentName: "Model", inMemory: true) { _ in
            xp.fulfill()
        }
        queue.addOperation(loadOp)
        wait(for: [xp], timeout: setupTimeout)
        
        guard let result = loadOp.result
            else {
                XCTFail(BRTest.fail(#function, type: .noResult))
                fatalError()
        }
        
        switch result {
        case .success(let container):
            self.container = container
            completion?()
        case .error(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        container = nil
    }
    
    
    
}


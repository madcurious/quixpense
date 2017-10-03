//
//  CoreDataTestCase.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import CoreData
import Mold
@testable import Spare

class CoreDataTestCase: XCTestCase {
    
    var coreDataStack: NSPersistentContainer!
    var operationQueue = OperationQueue()
    
    var setupTimeout = TimeInterval(60)
    
    override func setUp() {
        super.setUp()
        
        operationQueue = OperationQueue()
        
        let xp = expectation(description: "\(#function)\(#line)")
        loadCoreDataStack {
            xp.fulfill()
        }
        wait(for: [xp], timeout: setupTimeout)
    }
    
    func loadCoreDataStack(completion: (() -> Void)?) {
        let xp = expectation(description: #function)
        operationQueue.addOperation(
            LoadCoreDataStackOperation(inMemory: true) {[unowned self] result in
                switch result {
                case .success(let container):
                    self.coreDataStack = container
                    completion?()
                default:
                    fatalError(#function)
                }
                xp.fulfill()
        })
        wait(for: [xp], timeout: setupTimeout)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
    }
    
    func makeFetchControllerForAllExpenses() -> NSFetchedResultsController<Expense> {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Expense.dateSpent), ascending: true)
            ]
            let frc = NSFetchedResultsController<Expense>(fetchRequest: request,
                                                          managedObjectContext: coreDataStack.viewContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
            return frc
    }
    
    func makeValidExpense(from rawExpense: RawExpense) -> ValidExpense {
        let validateOp = ValidateExpenseOperation(rawExpense: rawExpense, context: coreDataStack.viewContext, completionBlock: nil)
        validateOp.start()
        if case .success(let validExpense) = validateOp.result {
            return validExpense
        }
        fatalError()
    }
    
}

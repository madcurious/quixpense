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
    
//    func makeExpenses(from rawExpenses: [RawExpense]) {
//        for rawExpense in rawExpenses {
//            let addOp = AddExpenseOperation(context: coreDataStack.newBackgroundContext(), validExpense: rawExpense, completionBlock: nil)
//            addOp.start()
//        }
//    }
    
//    func makeValidEnteredExpense(from rawExpense: RawExpense) -> ValidExpense {
//        let validateOp = ValidateExpenseOperation(rawExpense: rawExpense, context: coreDataStack.newBackgroundContext(), completionBlock: nil)
//        validateOp.start()
//        
//        switch validateOp.result {
//        case .success(let validExpense):
//            return validExpense
//        case .error(let error):
//            fatalError("\(#function) - Error received: \(error)")
//        default:
//            fatalError("\(#function) - No result found.")
//        }
//    }
    
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
    
}

//
//  WriteExpenseTest.swift
//  QuixpenseTests
//
//  Created by Matt Quiros on 15/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import XCTest
@testable import Quixpense
import CoreData
import Bedrock

class WriteExpenseTest: CoreDataTest {}

// MARK: - Classifiers
extension WriteExpenseTest {
    
    func testClassifiers_nil_shouldBeNone() {
        let expense = TestUtil.makeValidExpense(from:
            RawExpense(amount: "200",
                       dateSpent: Date(),
                       category: nil,
                       tags: nil
                ))
        
        let xp = expectation(description: "\(#function)\(#line)")
        let writeOp = WriteExpense(context: container.newBackgroundContext(),
                                   validExpense: expense,
                                   objectId: nil) { _ in
                                    xp.fulfill()
        }
        queue.addOperation(writeOp)
        wait(for: [xp], timeout: 60)
        
        guard let result = writeOp.result
            else {
                XCTFail(BRTest.fail(#function, type: .noResult))
                return
        }
        switch result {
        case .success(let objectId):
            guard let expense = container.viewContext.object(with: objectId) as? Expense,
                let category = expense.category,
                let tags = expense.tags
                else {
                    XCTFail(BRTest.fail(#function, type: .nil))
                    return
            }
            XCTAssertEqual(category, Classifier.default)
            XCTAssertEqual(tags, [Classifier.default])
        case .error(let error):
            XCTFail(BRTest.fail(#function, type: .error(error)))
        }
    }
    
}

//
//  class AddExpense_DayCategoryGroup.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/10/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Bedrock
import CoreData
@testable import Spare

class AddExpense_DayCategoryGroup: CoreDataTestCase {
    
    func testSectionIdentifier_shouldSucceed() {
        var components = DateComponents()
        components.day = 30
        components.month = 9
        components.year = 2017
        let date = Calendar.current.date(from: components)!
        let identifier = SectionIdentifier.make(referenceDate: date, periodization: .day)
        XCTAssertEqual(identifier, "\(Calendar.current.startOfDay(for: date).timeIntervalSince1970)-\(BRDateUtils.endOfDay(for: date).timeIntervalSince1970)")
    }
    
    func test_notYetExisting_shouldBeCreated() {
        let date = makeDate(day: 30, month: 9, year: 2017)
        let sectionId = SectionIdentifier.make(referenceDate: date, periodization: .day)
        let categoryName = "Transportation"
        
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<DayCategoryGroup> = DayCategoryGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(DayCategoryGroup.sectionIdentifier), sectionId,
                                             #keyPath(DayCategoryGroup.classifier.name), categoryName
        )
        XCTAssertNil(try! context.fetch(fetchRequest).first)
        
        let validExpense = makeValidExpense(from: RawExpense(amount: "200", dateSpent: date, categorySelection: .new(categoryName), tagSelection: .none))
        let addOp = AddExpenseOperation(context: context, validExpense: validExpense, completionBlock: nil)
        addOp.start()
        
        let group = try! context.fetch(fetchRequest).first
        XCTAssertNotNil(group)
        XCTAssertEqual(group?.sectionIdentifier, sectionId)
        XCTAssertEqual(group?.total, NSDecimalNumber(value: 200))
        XCTAssertEqual(group?.classifier?.name, categoryName)
        XCTAssertEqual(group?.expenses?.count, 1)
    }
    
}

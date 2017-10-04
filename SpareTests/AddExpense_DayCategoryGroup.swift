//
//  class AddExpense_DayCategoryGroup.swift
//  SpareTests
//
//  Created by Matt Quiros on 02/10/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import XCTest
import Mold
@testable import Spare

class AddExpense_DayCategoryGroup: CoreDataTestCase {
    
    func testSectionIdentifier_shouldSucceed() {
        var components = DateComponents()
        components.day = 30
        components.month = 9
        components.year = 2017
        let date = Calendar.current.date(from: components)!
        let identifier = SectionIdentifier.make(referenceDate: date, periodization: .day)
        XCTAssertEqual(identifier, "\(Calendar.current.startOfDay(for: date).timeIntervalSince1970)-\(TBDateUtils.endOfDay(for: date).timeIntervalSince1970)")
    }
    
}

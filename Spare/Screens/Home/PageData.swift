//
//  PageData.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

/**
 Represents a single page in the home screen.
 */
struct PageData: Equatable {
    
    var dateRange: DateRange
    var dateRangeTotal: NSDecimalNumber
    
    init() {
        self.dateRange = DateRange()
        self.dateRangeTotal = 0
    }
    
    init(dateRange: DateRange, dateRangeTotal: NSDecimalNumber) {
        self.dateRange = dateRange
        self.dateRangeTotal = dateRangeTotal
    }
    
}

func ==(lhs: PageData, rhs: PageData) -> Bool {
    return lhs.dateRange == rhs.dateRange &&
    lhs.dateRangeTotal == rhs.dateRangeTotal
}

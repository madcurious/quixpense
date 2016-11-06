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
    var total: NSDecimalNumber
    
    init() {
        self.dateRange = DateRange()
        self.total = 0
    }
    
    init(dateRange: DateRange, total: NSDecimalNumber) {
        self.dateRange = dateRange
        self.total = total
    }
    
}

func ==(lhs: PageData, rhs: PageData) -> Bool {
    return lhs.dateRange == rhs.dateRange &&
    lhs.total == rhs.total
}

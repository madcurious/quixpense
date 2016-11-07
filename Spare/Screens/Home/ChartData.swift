//
//  ChartData.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

struct ChartData {
    
    var category: Category
    private var pageData: PageData
    var categoryTotal: NSDecimalNumber?
    var percent: Double?
    
    var dateRange: DateRange {
        return self.pageData.dateRange
    }
    
    var dateRangeTotal: NSDecimalNumber {
        return self.pageData.dateRangeTotal
    }
    
    init() {
        self.category = Category(entity: Category.entity(), insertInto: nil)
        self.pageData = PageData()
    }
    
    init(category: Category, pageData: PageData) {
        self.category = category
        self.pageData = pageData
    }
    
}

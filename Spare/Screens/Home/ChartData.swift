//
//  ChartData.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

struct ChartData {
    
//    var category: Category
    var categoryID: NSManagedObjectID
    var dateRange: DateRange
    var dateRangeTotal: NSDecimalNumber
    var categoryTotal: NSDecimalNumber
    var ratio: Double
    
    var category: Category? {
        return App.mainQueueContext.object(with: self.categoryID) as? Category
    }
    
//    init() {
//        self.category = Category(entity: Category.entity(), insertInto: nil)
//        self.dateRange = DateRange()
//        self.dateRangeTotal = 0
//        self.categoryTotal = 0
//        self.ratio = 0
//    }
//    
//    init(category: Category, pageData: PageData) {
//        self.category = category
//        self.dateRange = pageData.dateRange
//        self.dateRangeTotal = pageData.dateRangeTotal
//        self.categoryTotal = 0
//        self.ratio = 0
//    }
    
}

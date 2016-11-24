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
    
    var categoryID: NSManagedObjectID
    var dateRange: DateRange
    var dateRangeTotal: NSDecimalNumber
    var categoryTotal: NSDecimalNumber
    var ratio: Double
    
    var category: Category? {
        return App.mainQueueContext.object(with: self.categoryID) as? Category
    }
    
}

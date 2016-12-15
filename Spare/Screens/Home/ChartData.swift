//
//  ChartData.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

struct ChartData {
    
    var categoryID: NSManagedObjectID
    var dateRangeTotal: NSDecimalNumber
    var categoryTotal: NSDecimalNumber
    
    var dates: [String]?
    var weekdays: [String]?
    var dailyAverage: NSDecimalNumber?
    var percentages: [CGFloat]?
    
    var ratio: Double {
        guard self.dateRangeTotal > 0
            else {
                return 0
        }
        return Double(self.categoryTotal / self.dateRangeTotal)
    }
    
    var category: Category? {
        return App.mainQueueContext.object(with: self.categoryID) as? Category
    }
    
}

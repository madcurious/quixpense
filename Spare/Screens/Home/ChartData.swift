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
    var periodization: Periodization
    
    var datesInWeek: [Int]?
    var weekdays: [String]?
    var dailyAverage: NSDecimalNumber?
    var monthlyAverage: NSDecimalNumber?
    var dailyPercentages: [CGFloat]?
    var monthlyPercentages: [CGFloat]?
    
    var categoryPercentage: CGFloat {
        guard self.dateRangeTotal > 0
            else {
                return 0
        }
        return CGFloat(self.categoryTotal / self.dateRangeTotal)
    }
    
    var category: Category? {
        return App.mainQueueContext.object(with: self.categoryID) as? Category
    }
    
    init(categoryID: NSManagedObjectID,
         dateRangeTotal: NSDecimalNumber,
         categoryTotal: NSDecimalNumber,
         periodization: Periodization) {
        self.categoryID = categoryID
        self.dateRangeTotal = dateRangeTotal
        self.categoryTotal = categoryTotal
        self.periodization = periodization
    }
    
//    init(categoryID: NSManagedObjectID, dateRangeTotal: NSDecimalNumber, categoryTotal: NSDecimalNumber, periodization: Periodization,
//         datesInWeek: [Int]? = nil, weekdays: [String]? = nil, dailyAverage: NSDecimalNumber? = nil, monthlyAverage: NSDecimalNumber? = nil, dailyPercentages: [CGFloat]? = nil, monthlyPercentages: [CGFloat]? = nil) {
//        self.categoryID = categoryID
//        self.dateRangeTotal = dateRangeTotal
//        self.categoryTotal = categoryTotal
//        self.periodization = periodization
//        self.datesInWeek = datesInWeek
//        self.weekdays = weekdays
//        self.dailyAverage = dailyAverage
//        self.monthlyAverage = monthlyAverage
//        self.dailyPercentages = dailyPercentages
//        self.monthlyPercentages = monthlyPercentages
//    }
    
//    /// Used by week cells.
//    init(categoryID: NSManagedObjectID,
//         dateRangeTotal: NSDecimalNumber,
//         categoryTotal: NSDecimalNumber,
//         periodization: Periodization,
//         datesInWeek: [Int],
//         weekdays: [String],
//         dailyAverage: NSDecimalNumber,
//         dailyPercentages: [CGFloat]) {
//        self.init(categoryID: categoryID, dateRangeTotal: dateRangeTotal, categoryTotal: categoryTotal, periodization: periodization)
//        self.datesInWeek = datesInWeek
//        self.weekdays = weekdays
//        self.dailyAverage = dailyAverage
//        self.dailyPercentages = dailyPercentages
//    }
//    
//    /// Used by month cells.
//    init(categoryID: NSManagedObjectID,
//         dateRangeTotal: NSDecimalNumber,
//         categoryTotal: NSDecimalNumber,
//         periodization: Periodization,
//         dailyAverage: NSDecimalNumber,
//         dailyPercentages: [CGFloat]) {
//        self.init(categoryID: categoryID, dateRangeTotal: dateRangeTotal, categoryTotal: categoryTotal, periodization: periodization)
//        self.dailyAverage = dailyAverage
//        self.dailyPercentages = dailyPercentages
//    }
//    
//    /// Used by year cells.
//    init(categoryID: NSManagedObjectID,
//         dateRangeTotal: NSDecimalNumber,
//         categoryTotal: NSDecimalNumber,
//         periodization: Periodization,
//         monthlyAverage: NSDecimalNumber,
//         monthlyPercentages: [CGFloat]) {
//        self.init(categoryID: categoryID, dateRangeTotal: dateRangeTotal, categoryTotal: categoryTotal, periodization: periodization)
//        self.monthlyAverage = monthlyAverage
//        self.monthlyPercentages = monthlyPercentages
//    }
    
}

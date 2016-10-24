//
//  Summary.swift
//  Spare
//
//  Created by Matt Quiros on 14/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

struct Summary: Equatable {
    
    var startDate: Date
    var endDate: Date
    var periodization: Periodization
    
//    /**
//     Returns an array of all the expenses in the date range, or nil if none were found.
//     */
//    var expenses: [Expense]? {
//        let request = FetchRequestBuilder<Expense>.makeFetchRequest()
//        request.predicate = NSPredicate(format: "dateSpent >= %@ AND dateSpent <= %@", self.startDate as NSDate, self.endDate as NSDate)
//        if let expenses = try? App.mainQueueContext.fetch(request),
//            expenses.isEmpty == false {
//            return expenses
//        }
//        return nil
//    }
//    
//    /**
//     Returns the total of all the expenses in this date range.
//     */
//    var total: NSDecimalNumber {
//        guard let expenses = self.expenses
//            else {
//                return 0
//        }
//        
//        return glb_totalOfExpenses(expenses)
//    }
//    
//    /**
//     Returns an array of the category, their totals, and their percent of the total.
//     The array is ordered by biggest total first.
//     */
//    var data: [(Category, NSDecimalNumber, Double)]? {
//        let overallTotal = self.total
//        let groups = self.expenses?.groupBy({ $0.category })
//        var data = [(Category, NSDecimalNumber, Double)]()
//        
//        for category in App.allCategories() {
//            // If the category isn't in the grouping dictionary, then it doesn't have any expenses
//            // and its total should be set to 0.
//            guard let expenses = groups?[category]
//                else {
//                    data.append((category, NSDecimalNumber(value: 0 as Int), 0.0))
//                    continue
//            }
//            
//            let categoryTotal = glb_totalOfExpenses(expenses)
//            let categoryPercent = overallTotal == 0 ? 0 : categoryTotal.dividing(by: overallTotal).doubleValue
//            data.append((category, categoryTotal, categoryPercent))
//        }
//        
//        data.sort(by: { $0.2 > $1.2 })
//        
//        return data
//    }
    
    func containsDate(_ date: Date) -> Bool {
        // Get the date components.
        let calendar = Calendar.current
        let significantUnits: NSCalendar.Unit = [.month, .day, .year]
        let startDateComponents = (calendar as NSCalendar).components(significantUnits, from: self.startDate)
        let endDateComponents = (calendar as NSCalendar).components(significantUnits, from: self.endDate)
        let dateComponents = (calendar as NSCalendar).components(significantUnits, from: date)
        
        if (dateComponents.month! >= startDateComponents.month! &&
            dateComponents.day! >= startDateComponents.day! &&
            dateComponents.year! >= startDateComponents.year!) &&
            
            (dateComponents.month! <= endDateComponents.month! &&
                dateComponents.day! <= endDateComponents.day! &&
                dateComponents.year! <= endDateComponents.year!) {
            return true
        }
        
        return false
    }
    
}

func ==(lhs: Summary, rhs: Summary) -> Bool {
    return lhs.startDate == rhs.startDate &&
        lhs.endDate == rhs.endDate &&
        lhs.periodization == rhs.periodization
}

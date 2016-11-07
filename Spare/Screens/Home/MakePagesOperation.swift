//
//  MakePagesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 13/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

/**
 Makes an array of date ranges. Each date range represents a single page
 in the home screen.
 */
class MakePagesOperation: MDOperation {
    
    var currentDate: Date
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    var count: Int
    var pageOffset: Int
    
    /**
     - parameters:
        - currentDate: The current date, which will be the basis date of computation.
        - periodization: Defines whether summaries will be daily, weekly, monthly, or yearly.
        - startOfWeek: The user's definition of when a week starts (Saturday, Sunday, or Monday).
        - count: The number of summaries to be generated.
        - pageOffset: The number of pages to skip. Each page is assumed to have as many items as indicated in the `count` parameter.
     */
    init(currentDate: Date, periodization: Periodization, startOfWeek: StartOfWeek, count: Int, pageOffset: Int) {
        self.currentDate = currentDate
        self.periodization = periodization
        self.startOfWeek = startOfWeek
        self.count = count
        self.pageOffset = pageOffset
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        var pageData = [PageData]()
        
        // 1. For every i, generate the date range for the page.
        // 2. Then, get the total of all expenses in the date range.
        for i in 0 ..< self.count {
            // 1
            let dateRange = self.dateRangeForPage(self.pageOffset + i)
            
            if self.isCancelled {
                return nil
            }
            
            // 2
            
            let request = FetchRequestBuilder<Expense>.makeGenericFetchRequest()
            request.predicate = NSPredicate(
                format: "%K >= %@ AND %K <= %@",
                #keyPath(Expense.dateSpent), dateRange.start as NSDate,
                #keyPath(Expense.dateSpent), dateRange.end as NSDate
            )
            request.resultType = .dictionaryResultType
            
            let sumExpression = NSExpressionDescription()
            sumExpression.name = "sum"
            sumExpression.expression = NSExpression(forKeyPath: "@sum.amount")
            sumExpression.expressionResultType = .decimalAttributeType
            request.propertiesToFetch = [sumExpression]
            
            let context = App.coreDataStack.newBackgroundContext()
            guard let result = try context.fetch(request) as? [[String : NSDecimalNumber]],
                let dict = result.first,
                let total = dict["sum"]
                else {
                    return nil
            }
            
            let page = PageData(dateRange: dateRange, dateRangeTotal: total)
            pageData.insert(page, at: 0)
            
            if self.isCancelled {
                return nil
            }
        }
        return pageData
    }
    
    func dateRangeForPage(_ page: Int) -> DateRange {
        var calendar = Calendar.current
        
        switch self.periodization {
        case .day:
            // Offset the baseDate by page, then return the start and end of day.
            let offsetDate = calendar.date(byAdding: .day, value: page * -1, to: self.currentDate)!
            return DateRange(start: offsetDate.startOfDay(), end: offsetDate.endOfDay())
            
        case .week:
            calendar.firstWeekday = self.startOfWeek.rawValue
            
            let offsetDate = calendar.date(byAdding: .weekOfYear, value: page * -1, to: self.currentDate)!
            var startDate = Date.distantPast
            var interval = TimeInterval(0)
            let _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: offsetDate)
            let endDate = startDate.addingTimeInterval(interval - 1)
            return DateRange(start: startDate.startOfDay(), end: endDate.endOfDay())
            
        case .month:
            let offsetDate = calendar.date(byAdding: .month, value: page * -1, to: self.currentDate)!
            let startDate = calendar.date(bySetting: .day, value: 1, of: offsetDate)!
            
            let dayRange = calendar.range(of: .day, in: .month, for: offsetDate)!
            let endDate = calendar.date(bySetting: .day, value: dayRange.upperBound, of: offsetDate)!
            
            return DateRange(start: startDate.startOfDay(), end: endDate.endOfDay())
            
        case .year:
            let offsetDate = calendar.date(byAdding: .year, value: page * -1, to: self.currentDate)!
            var components = calendar.dateComponents([.month, .day, .year], from: offsetDate)
            
            components.month = 1
            components.day = 1
            let startDate = calendar.date(from: components)!
            
            components.month = calendar.range(of: .month, in: .year, for: offsetDate)!.upperBound
            let lastMonthInYear = calendar.date(from: components)!
            let dayRange = calendar.range(of: .day, in: .month, for: lastMonthInYear)!
            components.day = dayRange.upperBound
            let endDate = calendar.date(from: components)!
            
            return DateRange(start: startDate.startOfDay(), end: endDate.endOfDay())
        }
    }
    
}

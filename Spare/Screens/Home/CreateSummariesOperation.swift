//
//  CreateSummariesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 13/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

class CreateSummariesOperation: MDOperation {
    
    var baseDate: Date
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    var count: Int
    var startingPage: Int
    
    /**
     - parameters:
        - baseDate: The date from which summaries will be computed, usually the current date.
        - periodization: Defines whether summaries will be daily, weekly, monthly, or yearly.
        - startOfWeek: The user's definition of when a week starts (Saturday, Sunday, or Monday).
        - count: The number of summaries to be generated.
        - startingPage: The page offset, also uses the `count` parameter to compute the offset.
     */
    init(baseDate: Date, periodization: Periodization, startOfWeek: StartOfWeek, count: Int, startingPage: Int) {
        self.baseDate = baseDate
        self.periodization = periodization
        self.startOfWeek = startOfWeek
        self.count = count
        self.startingPage = startingPage
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        var summaries = [Summary]()
        for i in 0 ..< self.count {
            let (startDate, endDate) = self.dateRangeForPage(self.startingPage + i)
            let summary = Summary(startDate: startDate, endDate: endDate, periodization: self.periodization)
            summaries.insert(summary, at: 0)
            
            if self.isCancelled {
                return nil
            }
        }
        return summaries
    }
    
    func dateRangeForPage(_ page: Int) -> (Date, Date) {
        var calendar = Calendar.current
        
        switch self.periodization {
        case .day:
            // Offset the baseDate by page, then return the start and end of day.
            let offsetDate = calendar.date(byAdding: .day, value: page * -1, to: self.baseDate)!
            return (offsetDate.startOfDay(), offsetDate.endOfDay())
            
        case .week:
            calendar.firstWeekday = self.startOfWeek.rawValue
            
            let offsetDate = calendar.date(byAdding: .weekOfYear, value: page * -1, to: self.baseDate)!
            var startDate = Date.distantPast
            var interval = TimeInterval(0)
            let _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: offsetDate)
            let endDate = startDate.addingTimeInterval(interval - 1)
            return (startDate, endDate)
            
        case .month:
//            let referenceDate = (calendar as NSCalendar).date(byAdding: .month, value: page * -1, to: self.baseDate, options: [])!
//            
//            var components = (calendar as NSCalendar).components([.month, .day, .year], from: referenceDate)
//            components.day = 1
//            let startDate = calendar.date(from: components)!
//            
//            let dayRange = (calendar as NSCalendar).range(of: .day, in: .month, for: referenceDate)
//            components.day = dayRange.length
//            let endDate = calendar.date(from: components)!
//            
//            return (startDate, endDate)
            let offsetDate = calendar.date(byAdding: .month, value: page * -1, to: self.baseDate)!
            let startDate = calendar.date(bySetting: .day, value: 1, of: offsetDate)!
            
            let dayRange = calendar.range(of: .day, in: .month, for: offsetDate)!
            let endDate = calendar.date(bySetting: .day, value: dayRange.upperBound, of: offsetDate)!
            
            return (startDate, endDate)
            
        case .year:
//            let referenceDate = (calendar as NSCalendar).date(byAdding: .year, value: page * -1, to: self.baseDate, options: [])!
//            
//            var components = (calendar as NSCalendar).components([.month, .day, .year], from: referenceDate)
//            components.month = 1
//            components.day = 1
//            let startDate = calendar.date(from: components)!
//            
//            let monthRange = (calendar as NSCalendar).range(of: .month, in: .year, for: referenceDate)
//            components.month = monthRange.length
//            let lastMonthInYear = calendar.date(from: components)!
//            let dayRange = (calendar as NSCalendar).range(of: .day, in: .month, for: lastMonthInYear)
//            components.day = dayRange.length
//            let endDate = calendar.date(from: components)!
//            
//            return (startDate, endDate)
            
            let offsetDate = calendar.date(byAdding: .year, value: page * -1, to: self.baseDate)!
            var components = calendar.dateComponents([.month, .day, .year], from: offsetDate)
            
            components.month = 1
            components.day = 1
            let startDate = calendar.date(from: components)!
            
            components.month = calendar.range(of: .month, in: .year, for: offsetDate)!.upperBound
            let lastMonthInYear = calendar.date(from: components)!
            let dayRange = calendar.range(of: .day, in: .month, for: lastMonthInYear)!
            components.day = dayRange.upperBound
            let endDate = calendar.date(from: components)!
            
            return (startDate, endDate)
        }
    }
    
}

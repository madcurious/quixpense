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
    
    var baseDate: NSDate
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    var count: Int
    var startingPage: Int
    
    init(baseDate: NSDate, periodization: Periodization, startOfWeek: StartOfWeek, count: Int, startingPage: Int) {
        self.baseDate = baseDate
        self.periodization = periodization
        self.startOfWeek = startOfWeek
        self.count = count
        self.startingPage = startingPage
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        var summaries = [Summary]()
        for i in 0 ..< self.count {
            let (startDate, endDate) = self.dateRangeForPage(self.startingPage + i)
            let summary = Summary(startDate: startDate, endDate: endDate, periodization: self.periodization)
            summaries.insert(summary, atIndex: 0)
            
            if self.cancelled {
                return nil
            }
        }
        return summaries
    }
    
    func dateRangeForPage(page: Int) -> (NSDate, NSDate) {
        let calendar = NSCalendar.currentCalendar().copy() as! NSCalendar
        
        switch self.periodization {
        case .Day:
            let date = calendar.dateByAddingUnit(.Day, value: page * -1, toDate: self.baseDate, options: [])!
            return (date.firstMoment(), date.lastMoment())
            
        case .Week:
            calendar.firstWeekday = self.startOfWeek.rawValue
            let referenceDate = calendar.dateByAddingUnit(.WeekOfYear, value: page * -1, toDate: self.baseDate, options: [])!
            var startDate: NSDate?
            var interval = NSTimeInterval(0)
            calendar.rangeOfUnit(.WeekOfYear, startDate: &startDate, interval: &interval, forDate: referenceDate)
            let endDate = startDate!.dateByAddingTimeInterval(interval - 1)
            return (startDate!, endDate)
            
        case .Month:
            let referenceDate = calendar.dateByAddingUnit(.Month, value: page * -1, toDate: self.baseDate, options: [])!
            
            let components = calendar.components([.Month, .Day, .Year], fromDate: referenceDate)
            components.day = 1
            let startDate = calendar.dateFromComponents(components)!
            
            let dateRange = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: referenceDate)
            components.day = dateRange.length
            let endDate = calendar.dateFromComponents(components)!
            
            return (startDate, endDate)
            
            
        default:
            break
        }
        
        fatalError()
    }
    
}

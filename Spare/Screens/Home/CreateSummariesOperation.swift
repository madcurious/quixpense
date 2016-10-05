//
//  CreateSummariesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 13/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

enum CreateSummariesOperationError: Error {
    case noCategoriesYet
    
    var localizedDescription: String {
        switch self {
        case .noCategoriesYet:
            return "You have no categories yet! Press and hold the ＋ button to add one."
        }
    }
    
}

class CreateSummariesOperation: MDOperation {
    
    var baseDate: Date
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    var count: Int
    var startingPage: Int
    
    init(baseDate: Date, periodization: Periodization, startOfWeek: StartOfWeek, count: Int, startingPage: Int) {
        self.baseDate = baseDate
        self.periodization = periodization
        self.startOfWeek = startOfWeek
        self.count = count
        self.startingPage = startingPage
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        guard let _ = App.allCategories()
            else {
                throw CreateSummariesOperationError.noCategoriesYet
        }
        
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
            let date = (calendar as NSCalendar).date(byAdding: .day, value: page * -1, to: self.baseDate, options: [])!
            return (date.startOfDay(), date.endOfDay())
            
        case .week:
            calendar.firstWeekday = self.startOfWeek.rawValue
            let referenceDate = (calendar as NSCalendar).date(byAdding: .weekOfYear, value: page * -1, to: self.baseDate, options: [])!
            var startDate: Date?
            var interval = TimeInterval(0)
            (calendar as NSCalendar).range(of: .weekOfYear, start: &startDate, interval: &interval, for: referenceDate)
            let endDate = startDate!.addingTimeInterval(interval - 1)
            return (startDate!, endDate)
            
        case .month:
            let referenceDate = (calendar as NSCalendar).date(byAdding: .month, value: page * -1, to: self.baseDate, options: [])!
            
            var components = (calendar as NSCalendar).components([.month, .day, .year], from: referenceDate)
            components.day = 1
            let startDate = calendar.date(from: components)!
            
            let dayRange = (calendar as NSCalendar).range(of: .day, in: .month, for: referenceDate)
            components.day = dayRange.length
            let endDate = calendar.date(from: components)!
            
            return (startDate, endDate)
            
        case .year:
            let referenceDate = (calendar as NSCalendar).date(byAdding: .year, value: page * -1, to: self.baseDate, options: [])!
            
            var components = (calendar as NSCalendar).components([.month, .day, .year], from: referenceDate)
            components.month = 1
            components.day = 1
            let startDate = calendar.date(from: components)!
            
            let monthRange = (calendar as NSCalendar).range(of: .month, in: .year, for: referenceDate)
            components.month = monthRange.length
            let lastMonthInYear = calendar.date(from: components)!
            let dayRange = (calendar as NSCalendar).range(of: .day, in: .month, for: lastMonthInYear)
            components.day = dayRange.length
            let endDate = calendar.date(from: components)!
            
            return (startDate, endDate)
        }
    }
    
}

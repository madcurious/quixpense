//
//  DateFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

private let kSharedFormatter: Foundation.DateFormatter = {
    let formatter = Foundation.DateFormatter()
    formatter.timeZone = TimeZone.autoupdatingCurrent
    return formatter
}()

class DateFormatter {
    
    class func displayTextForStartDate(_ startDate: Date, endDate: Date, periodization: Periodization = App.state.selectedPeriodization, startOfWeek: StartOfWeek = App.state.selectedStartOfWeek) -> String {
        let dateRange = DateRange(startDate: startDate,
                                           endDate: endDate,
                                           periodization: periodization,
                                           startOfWeek: startOfWeek)
        return dateRange.displayText()
    }
    
    class func displayTextForSummary(_ summary: Summary) -> String {
        let dateRange = DateRange(startDate: summary.startDate as Date,
                                           endDate: summary.endDate as Date,
                                           periodization: summary.periodization,
                                           startOfWeek: App.state.selectedStartOfWeek)
        return dateRange.displayText()
    }
    
    class func displayTextForExpenseEditorDate(_ date: Date?) -> String {
        guard let date = date
            else {
                return ""
        }
        
        kSharedFormatter.dateFormat = "EEE, d MMM yyyy"
        
        let currentDate = Date()
        if date.isSameDayAsDate(currentDate) {
            kSharedFormatter.dateFormat = "d MMM yyyy"
            return "Today, " + kSharedFormatter.string(from: date)
        }
        return kSharedFormatter.string(from: date)
    }
    
}

private struct DateRange {
    
    var startDate: Date
    var endDate: Date
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    
    func displayText() -> String {
        switch self.periodization {
        case .day:
            return self.displayTextForDay()
            
        case .week:
            return self.displayTextForWeek()
            
        case .month:
            return self.displayTextForMonth()
            
        case .year:
            return self.displayTextForYear()
        }
    }
    
    fileprivate func displayTextForDay() -> String {
        if self.startDate.isSameDayAsDate(Date()) {
            return "Today"
        } else {
            kSharedFormatter.dateFormat = "EEE, MMM d"
            return kSharedFormatter.string(from: self.startDate)
        }
    }
    
    fileprivate func displayTextForWeek() -> String {
        let currentDate = Date()
        if self.startDate.isSameWeekAsDate(currentDate, whenFirstWeekdayIs: self.startOfWeek.rawValue) {
            return "This week"
        } else {
            let formatter = kSharedFormatter
            switch (self.startDate.isSameYearAsDate(currentDate), self.endDate.isSameYearAsDate(currentDate)) {
            case (true, true):
                formatter.dateFormat = "MMM d"
                
            default:
                formatter.dateFormat = "MMM d ''yy"
            }
            return "\(formatter.string(from: self.startDate)) to \(formatter.string(from: self.endDate))"
        }
    }
    
    fileprivate func displayTextForMonth() -> String {
        let currentDate = Date()
        if self.startDate.isSameMonthAsDate(currentDate) {
            return "This month"
        }
        
        let formatter = kSharedFormatter
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self.startDate)
    }
    
    fileprivate func displayTextForYear() -> String {
        let currentDate = Date()
        if self.startDate.isSameYearAsDate(currentDate) {
            return "This year"
        }
        
        let formatter = kSharedFormatter
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self.startDate)
    }
    
}

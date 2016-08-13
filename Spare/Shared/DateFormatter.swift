//
//  DateFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

private let kSharedFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.timeZone = NSTimeZone.localTimeZone()
    return formatter
}()

class DateFormatter {
    
    class func displayTextForStartDate(startDate: NSDate, endDate: NSDate, periodization: Periodization = App.state.selectedPeriodization, startOfWeek: StartOfWeek = App.state.selectedStartOfWeek) -> String {
        let dateRange = DateRange(startDate: startDate,
                                           endDate: endDate,
                                           periodization: periodization,
                                           startOfWeek: startOfWeek)
        return dateRange.displayText()
    }
    
    class func displayTextForSummary(summary: Summary) -> String {
        let dateRange = DateRange(startDate: summary.startDate,
                                           endDate: summary.endDate,
                                           periodization: summary.periodization,
                                           startOfWeek: App.state.selectedStartOfWeek)
        return dateRange.displayText()
    }
    
    class func displayTextForExpenseEditorDate(date: NSDate?) -> String {
        guard let date = date
            else {
                return ""
        }
        
        kSharedFormatter.dateFormat = "MMM d, yyyy"
        
        let currentDate = NSDate()
        if date.isSameDayAsDate(currentDate) {
            return "Today, " + kSharedFormatter.stringFromDate(date)
        }
        return kSharedFormatter.stringFromDate(date)
    }
    
}

private struct DateRange {
    
    var startDate: NSDate
    var endDate: NSDate
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    
    func displayText() -> String {
        switch self.periodization {
        case .Day:
            return self.displayTextForDay()
            
        case .Week:
            return self.displayTextForWeek()
            
        case .Month:
            return self.displayTextForMonth()
            
        case .Year:
            return self.displayTextForYear()
        }
    }
    
    private func displayTextForDay() -> String {
        if self.startDate.isSameDayAsDate(NSDate()) {
            return "Today"
        } else {
            kSharedFormatter.dateFormat = "EEE, MMM d"
            return kSharedFormatter.stringFromDate(self.startDate)
        }
    }
    
    private func displayTextForWeek() -> String {
        let currentDate = NSDate()
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
            return "\(formatter.stringFromDate(self.startDate)) to \(formatter.stringFromDate(self.endDate))"
        }
    }
    
    private func displayTextForMonth() -> String {
        let currentDate = NSDate()
        if self.startDate.isSameMonthAsDate(currentDate) {
            return "This month"
        }
        
        let formatter = kSharedFormatter
        formatter.dateFormat = "MMM yyyy"
        return formatter.stringFromDate(self.startDate)
    }
    
    private func displayTextForYear() -> String {
        let currentDate = NSDate()
        if self.startDate.isSameYearAsDate(currentDate) {
            return "This year"
        }
        
        let formatter = kSharedFormatter
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(self.startDate)
    }
    
}

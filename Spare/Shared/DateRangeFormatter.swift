//
//  DateRangeFormatter.swift
//  Spare
//
//  Created by Matt Quiros on 04/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

struct DateRangeFormatter {
    
    var startDate: NSDate
    var endDate: NSDate
    var periodization: Periodization
    var startOfWeek: StartOfWeek
    
    private static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter
    }()
    
    static func displayTextForStartDate(startDate: NSDate, endDate: NSDate, periodization: Periodization = App.state.selectedPeriodization, startOfWeek: StartOfWeek = App.state.selectedStartOfWeek) -> String {
        let formatter = DateRangeFormatter(startDate: startDate,
                                           endDate: endDate,
                                           periodization: periodization,
                                           startOfWeek: startOfWeek)
        return formatter.displayText()
    }
    
    static func displayTextForSummary(summary: Summary) -> String {
        let formatter = DateRangeFormatter(startDate: summary.startDate,
                                           endDate: summary.endDate,
                                           periodization: summary.periodization,
                                           startOfWeek: App.state.selectedStartOfWeek)
        return formatter.displayText()
    }
    
    
    
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
            DateRangeFormatter.formatter.dateFormat = "EEE, MMM d"
            return DateRangeFormatter.formatter.stringFromDate(self.startDate)
        }
    }
    
    private func displayTextForWeek() -> String {
        let currentDate = NSDate()
        if self.startDate.isSameWeekAsDate(currentDate, whenFirstWeekdayIs: self.startOfWeek.rawValue) {
            return "This week"
        } else {
            let formatter = DateRangeFormatter.formatter
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
        fatalError()
    }
    
    private func displayTextForYear() -> String {
        fatalError()
    }
    
}
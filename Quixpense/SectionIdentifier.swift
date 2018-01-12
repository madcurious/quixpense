//
//  SectionIdentifier.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock

class SectionIdentifier {
    
    class func make(for date: Date, period: Period) -> String {
        let startDate: Date
        let endDate: Date
        
        switch period {
        case .day:
            startDate = Calendar.current.startOfDay(for: date)
            endDate = BRDateUtil.endOfDay(for: date)
            
        case .week:
            let firstWeekday = Calendar.current.firstWeekday
            startDate = BRDateUtil.startOfWeek(for: date, firstWeekday: firstWeekday)
            endDate = BRDateUtil.endOfWeek(for: date, firstWeekday: firstWeekday)
            
        case .month:
            startDate = BRDateUtil.startOfMonth(for: date)
            endDate = BRDateUtil.endOfMonth(for: date)
        }
        
        return "\(startDate.timeIntervalSince1970)-\(endDate.timeIntervalSince1970)"
    }
    
    class func parse(_ sectionIdentifier: String) -> (Date, Date) {
        let tokens = sectionIdentifier.components(separatedBy: "-")
        let startDate = Date(timeIntervalSince1970: TimeInterval(tokens[0])!)
        let endDate = Date(timeIntervalSince1970: TimeInterval(tokens[1])!)
        return (startDate, endDate)
    }
    
}

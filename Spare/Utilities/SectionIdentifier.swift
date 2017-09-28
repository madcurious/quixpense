//
//  SectionIdentifier.swift
//  Spare
//
//  Created by Matt Quiros on 12/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

final class SectionIdentifier {
    
    class func make(dateSpent: Date, periodization: Periodization) -> String {
        let startDate: Date
        let endDate: Date
        
        switch periodization {
        case .day:
            startDate = dateSpent.startOfDay()
            endDate = dateSpent.endOfDay()
            
        case .week:
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = dateSpent.startOfWeek(firstWeekday: firstWeekday)
            endDate = dateSpent.endOfWeek(firstWeekday: firstWeekday)
            
        case .month:
            startDate = dateSpent.startOfMonth()
            endDate = dateSpent.endOfMonth()
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

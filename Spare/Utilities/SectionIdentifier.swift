//
//  SectionIdentifier.swift
//  Spare
//
//  Created by Matt Quiros on 12/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

final class SectionIdentifier {
    
    class func make(referenceDate: Date, periodization: Periodization) -> String {
        let startDate: Date
        let endDate: Date
        
        switch periodization {
        case .day:
            startDate = referenceDate.startOfDay()
            endDate = referenceDate.endOfDay()
            
        case .week:
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = referenceDate.startOfWeek(firstWeekday: firstWeekday)
            endDate = referenceDate.endOfWeek(firstWeekday: firstWeekday)
            
        case .month:
            startDate = referenceDate.startOfMonth()
            endDate = referenceDate.endOfMonth()
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

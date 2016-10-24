//
//  DateRange.swift
//  Spare
//
//  Created by Matt Quiros on 24/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

struct DateRange: Equatable {
    
    var start: Date
    var end: Date
    
    func contains(date: Date) -> Bool {
        let calendar = Calendar.current
        let significantUnits: Set<Calendar.Component> = [.month, .day, .year]
        
        let startComponents = calendar.dateComponents(significantUnits, from: self.start)
        let endComponents = calendar.dateComponents(significantUnits, from: self.end)
        let dateComponents = calendar.dateComponents(significantUnits, from: date)
        
        if (dateComponents.month! >= startComponents.month! &&
            dateComponents.day! >= startComponents.day! &&
            dateComponents.year! >= startComponents.year!) &&
            
            (dateComponents.month! <= endComponents.month! &&
                dateComponents.day! <= endComponents.day! &&
                dateComponents.year! <= endComponents.year!) {
            return true
        }
        
        return false
    }
    
}

func ==(lhs: DateRange, rhs: DateRange) -> Bool {
    return lhs.start == rhs.start &&
        lhs.end == rhs.end
}

func !=(lhs: DateRange, rhs: DateRange) -> Bool {
    return !(lhs == rhs)
}

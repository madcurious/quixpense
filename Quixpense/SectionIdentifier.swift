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
    
    class func makeAll(for date: Date) -> [String : String] {
        func join(_ date1: Date, _ date2: Date) -> String {
            return "\(date1.timeIntervalSince1970)-\(date2.timeIntervalSince1970)"
        }
        
        return [
            #keyPath(Expense.daySectionId) :
                join(Calendar.current.startOfDay(for: date), BRDateUtil.endOfDay(for: date)),
            #keyPath(Expense.weekSectionIdSunday) :
                join(BRDateUtil.startOfWeek(for: date, firstWeekday: 1), BRDateUtil.endOfWeek(for: date, firstWeekday: 1)),
            #keyPath(Expense.weekSectionIdMonday) :
                join(BRDateUtil.startOfWeek(for: date, firstWeekday: 2), BRDateUtil.endOfWeek(for: date, firstWeekday: 2)),
            #keyPath(Expense.weekSectionIdSaturday) :
                join(BRDateUtil.startOfWeek(for: date, firstWeekday: 7), BRDateUtil.endOfWeek(for: date, firstWeekday: 7)),
            #keyPath(Expense.monthSectionId) :
                join(BRDateUtil.startOfMonth(for: date), BRDateUtil.endOfMonth(for: date))
        ]
    }
    
}

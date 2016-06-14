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
    var count: Int
    var precount: Int
    
    init(baseDate: NSDate, periodization: Periodization, count: Int, precount: Int) {
        self.baseDate = baseDate
        self.periodization = periodization
        self.count = count
        self.precount = precount
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        var summaries = [Summary]()
        for i in 0 ..< self.count {
            let (startDate, endDate) = self.dateRangeForPage(self.precount + i)
            let summary = Summary(startDate: startDate, endDate: endDate, periodization: self.periodization)
            summaries.insert(summary, atIndex: 0)
            
            if self.cancelled {
                return nil
            }
        }
        return summaries
    }
    
    func dateRangeForPage(page: Int) -> (NSDate, NSDate) {
        let calendar = NSCalendar.currentCalendar()
        switch self.periodization {
        case .Day:
            let date = calendar.dateByAddingUnit(.Day, value: page * -1, toDate: self.baseDate, options: [])!
            return (date.firstMoment(), date.lastMoment())
            
        default:
            fatalError()
        }
    }
    
}

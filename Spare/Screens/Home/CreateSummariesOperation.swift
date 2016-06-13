//
//  CreateSummariesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 13/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class CreateSummariesOperation: MDOperation {
    
    var parentContext: NSManagedObjectContext
    var baseDate: NSDate
    var summarization: Summarization
    var count: Int
    var precount: Int
    
    init(context: NSManagedObjectContext, baseDate: NSDate, summarization: Summarization, count: Int, precount: Int) {
        self.parentContext = context
        self.baseDate = baseDate
        self.summarization = summarization
        self.count = count
        self.precount = precount
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.parentContext
        
        for i in 0 ..< self.count {
            let (startDate, endDate) = self.dateRangeForPage(self.precount + i)
            let summary = Summary(managedObjectContext: context)
            summary.startDate = startDate
            summary.endDate = endDate
        }
        
        try context.save()
        return nil
    }
    
    func dateRangeForPage(page: Int) -> (NSDate, NSDate) {
        let calendar = NSCalendar.currentCalendar()
        switch self.summarization {
        case .Day:
            let date = calendar.dateByAddingUnit(.Day, value: page, toDate: self.baseDate, options: [])!
            return (date.firstMoment(), date.lastMoment())
            
        default:
            fatalError()
        }
    }
    
}

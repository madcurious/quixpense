//
//  Expense+Extension.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

extension Expense {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = Date() as NSDate
        self.setupKeyValueObserving()
    }
    
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        self.setupKeyValueObserving()
    }
    
    public override func awake(fromSnapshotEvents flags: NSSnapshotEventType) {
        super.awake(fromSnapshotEvents: flags)
        self.computeSectionIdentifiers()
    }
    
    func setupKeyValueObserving() {
        self.addObserver(self, forKeyPath: #keyPath(Expense.dateSpent), options: [.new], context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(Expense.dateSpent)
            else {
                return
        }
        
        self.computeSectionIdentifiers()
    }
    
    func computeSectionIdentifiers() {
        guard let dateSpent = self.dateSpent as Date?
            else {
                self.daySectionIdentifier = nil
                self.sundayWeekSectionIdentifier = nil
                self.mondayWeekSectionIdentifier = nil
                self.saturdayWeekSectionIdentifier = nil
                self.monthSectionIdentifier = nil
                return
        }
        
        let startOfDay = dateSpent.startOfDay().timeIntervalSince1970
        let endOfDay = dateSpent.endOfDay().timeIntervalSince1970
        
        let startOfSundayWeek = dateSpent.startOfWeek(firstWeekday: 1).timeIntervalSince1970
        let endOfSundayWeek = dateSpent.endOfWeek(firstWeekday: 1).timeIntervalSince1970
        
        let startOfMondayWeek = dateSpent.startOfWeek(firstWeekday: 2).timeIntervalSince1970
        let endOfMondayWeek = dateSpent.endOfWeek(firstWeekday: 2).timeIntervalSince1970
        
        let startOfSaturdayWeek = dateSpent.startOfWeek(firstWeekday: 7).timeIntervalSince1970
        let endOfSaturdayWeek = dateSpent.endOfWeek(firstWeekday: 7).timeIntervalSince1970
        
        let startOfMonth = dateSpent.startOfMonth().timeIntervalSince1970
        let endOfMonth = dateSpent.endOfMonth().timeIntervalSince1970
        
        self.daySectionIdentifier = "\(startOfDay)-\(endOfDay)"
        self.sundayWeekSectionIdentifier = "\(startOfSundayWeek)-\(endOfSundayWeek)"
        self.mondayWeekSectionIdentifier = "\(startOfMondayWeek)-\(endOfMondayWeek)"
        self.saturdayWeekSectionIdentifier = "\(startOfSaturdayWeek)-\(endOfSaturdayWeek)"
        self.monthSectionIdentifier = "\(startOfMonth)-\(endOfMonth)"
    }
    
}

extension Array where Element: Expense {
    
    func total() -> NSDecimalNumber {
        return self.map({ $0.amount ?? 0}).reduce(0, +)
    }
    
}

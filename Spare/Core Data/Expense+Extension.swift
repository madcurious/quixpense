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
    
    /// Automatically invoked by Core Data when the receiver is first inserted into a managed object context.
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = Date() as NSDate
        self.setupKVOForSectionDate()
    }
    
    /// Automatically invoked by Core Data when the managed object has been fetched.
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        self.setupKVOForSectionDate()
    }
    
    /// Automatically invoked by Core Data upon undo, redo, or "other multi-property state change."
    public override func awake(fromSnapshotEvents flags: NSSnapshotEventType) {
        super.awake(fromSnapshotEvents: flags)
        self.computeSectionDate()
    }
    
    func setupKVOForSectionDate() {
        self.addObserver(self, forKeyPath: #keyPath(Expense.dateSpent), options: [.new], context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Expense.dateSpent) {
            self.computeSectionDate()
        }
    }
    
    func computeSectionDate() {
        // Don't force-unwrap the optional in case the user attempts to save
        // an incomplete expense.
        guard let dateSpent = self.dateSpent as Date?
            else {
                self.sectionDate = nil
                return
        }
        
        // Remove the time components.
        let components = Calendar.current.dateComponents([.month, .day, .year], from: dateSpent)
        if let sectionDate = Calendar.current.date(from: components) {
            self.sectionDate = sectionDate as NSDate
        }
    }
    
}

extension Array where Element: Expense {
    
    func total() -> NSDecimalNumber {
        return self.map({ $0.amount ?? 0}).reduce(0, +)
    }
    
}

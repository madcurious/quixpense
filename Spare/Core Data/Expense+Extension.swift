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

fileprivate let kSectionDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    return dateFormatter
}()

extension Expense {
    
    class func sectionDateFomatter() -> DateFormatter {
        return kSectionDateFormatter
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.dateCreated = Date() as NSDate
        self.setupKVOForSectionDate()
    }
    
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        self.setupKVOForSectionDate()
    }
    
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
        guard let dateSpent = self.dateSpent as? Date
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

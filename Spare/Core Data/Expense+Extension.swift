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
    }
    
}

extension Array where Element: Expense {
    
    func total() -> NSDecimalNumber {
        return self.map({ $0.amount ?? 0}).reduce(0, +)
    }
    
}

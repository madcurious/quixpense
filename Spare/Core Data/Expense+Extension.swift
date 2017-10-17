//
//  Expense+Extension.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

fileprivate let kDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .long
    return formatter
}()

extension Expense {
    
    public func displayText() -> String {
        if let tags = (self.tags as? Set<Tag>)?.map({ $0.name! }) {
            return tags.joined(separator: ", ")
        } else {
            return kDateFormatter.string(from: self.dateSpent! as Date)
        }
    }
    
}

extension Sequence where Iterator.Element: Expense {
    
    func total() -> NSDecimalNumber {
        return self.map({ $0.amount ?? 0}).reduce(0, +)
    }
    
}

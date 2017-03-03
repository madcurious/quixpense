//
//  Expense+Extension.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

fileprivate let kSectionDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd"
    return dateFormatter
}()

extension Expense {
    
    var sectionIdentifier: String {
        let identifier = kSectionDateFormatter.string(from: self.dateSpent! as Date)
        return identifier
    }
    
}

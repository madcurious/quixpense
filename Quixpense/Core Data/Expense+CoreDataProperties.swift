//
//  Expense+CoreDataProperties.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var dateSpent: NSDate?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var category: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var daySection: String?
    @NSManaged public var weekSection: String?
    @NSManaged public var monthSection: String?

}

//
//  Expense+CoreDataProperties.swift
//  Quixpense
//
//  Created by Matt Quiros on 21/01/2018.
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
    @NSManaged public var category: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateSpent: NSDate?
    @NSManaged public var daySectionId: String?
    @NSManaged public var monthSectionId: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var weekSectionIdSunday: String?
    @NSManaged public var weekSectionIdMonday: String?
    @NSManaged public var weekSectionIdSaturday: String?

}

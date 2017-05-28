//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 28/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateSpent: NSDate?
    @NSManaged public var sectionDate: NSDate?
    @NSManaged public var category: Category?
    @NSManaged public var tags: Tag?

}

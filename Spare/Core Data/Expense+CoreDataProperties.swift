//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 15/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense");
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var dateSpent: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var paymentMethod: NSNumber?
    @NSManaged public var category: Category?

}

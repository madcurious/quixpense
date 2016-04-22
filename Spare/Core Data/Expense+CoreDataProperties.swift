//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Expense {

    @NSManaged var name: String?
    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var dateSpent: NSDate?
    @NSManaged var paymentMethod: NSNumber?
    @NSManaged var category: Category?

}

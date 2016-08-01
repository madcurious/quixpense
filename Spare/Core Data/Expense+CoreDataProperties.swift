//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Matt Quiros on 01/08/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Expense {

    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var dateSpent: NSDate?
    @NSManaged var note: String?
    @NSManaged var paymentMethod: NSNumber?
    @NSManaged var category: Category?

}

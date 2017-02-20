//
//  Subcategory+CoreDataProperties.swift
//  
//
//  Created by Matt Quiros on 21/02/2017.
//
//

import Foundation
import CoreData


extension Subcategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subcategory> {
        return NSFetchRequest<Subcategory>(entityName: "Subcategory");
    }

    @NSManaged public var name: String?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension Subcategory {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

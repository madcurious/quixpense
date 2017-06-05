//
//  CategorySection+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 05/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData


extension CategorySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategorySection> {
        return NSFetchRequest<CategorySection>(entityName: "CategorySection")
    }

    @NSManaged public var sectionDate: NSDate?
    @NSManaged public var total: NSDecimalNumber?
    @NSManaged public var category: Category?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension CategorySection {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

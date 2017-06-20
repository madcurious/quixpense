//
//  WeekCategoryGroup+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension WeekCategoryGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekCategoryGroup> {
        return NSFetchRequest<WeekCategoryGroup>(entityName: "WeekCategoryGroup")
    }

    @NSManaged public var sectionIdentifier: String?
    @NSManaged public var total: NSDecimalNumber?
    @NSManaged public var classifier: Category?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension WeekCategoryGroup {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

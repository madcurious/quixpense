//
//  Category+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 05/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var categorySections: NSSet?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for categorySections
extension Category {

    @objc(addCategorySectionsObject:)
    @NSManaged public func addToCategorySections(_ value: CategorySection)

    @objc(removeCategorySectionsObject:)
    @NSManaged public func removeFromCategorySections(_ value: CategorySection)

    @objc(addCategorySections:)
    @NSManaged public func addToCategorySections(_ values: NSSet)

    @objc(removeCategorySections:)
    @NSManaged public func removeFromCategorySections(_ values: NSSet)

}

// MARK: Generated accessors for expenses
extension Category {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

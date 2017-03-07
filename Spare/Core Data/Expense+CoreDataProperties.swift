//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 06/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
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
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var sectionDate: NSDate?
    @NSManaged public var category: Category?
    @NSManaged public var subcategories: NSOrderedSet?

}

// MARK: Generated accessors for subcategories
extension Expense {

    @objc(insertObject:inSubcategoriesAtIndex:)
    @NSManaged public func insertIntoSubcategories(_ value: Subcategory, at idx: Int)

    @objc(removeObjectFromSubcategoriesAtIndex:)
    @NSManaged public func removeFromSubcategories(at idx: Int)

    @objc(insertSubcategories:atIndexes:)
    @NSManaged public func insertIntoSubcategories(_ values: [Subcategory], at indexes: NSIndexSet)

    @objc(removeSubcategoriesAtIndexes:)
    @NSManaged public func removeFromSubcategories(at indexes: NSIndexSet)

    @objc(replaceObjectInSubcategoriesAtIndex:withObject:)
    @NSManaged public func replaceSubcategories(at idx: Int, with value: Subcategory)

    @objc(replaceSubcategoriesAtIndexes:withSubcategories:)
    @NSManaged public func replaceSubcategories(at indexes: NSIndexSet, with values: [Subcategory])

    @objc(addSubcategoriesObject:)
    @NSManaged public func addToSubcategories(_ value: Subcategory)

    @objc(removeSubcategoriesObject:)
    @NSManaged public func removeFromSubcategories(_ value: Subcategory)

    @objc(addSubcategories:)
    @NSManaged public func addToSubcategories(_ values: NSOrderedSet)

    @objc(removeSubcategories:)
    @NSManaged public func removeFromSubcategories(_ values: NSOrderedSet)

}

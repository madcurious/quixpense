//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 05/06/2017.
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
    @NSManaged public var category: Category?
    @NSManaged public var categorySection: CategorySection?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension Expense {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

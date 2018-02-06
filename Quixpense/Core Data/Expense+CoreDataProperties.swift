//
//  Expense+CoreDataProperties.swift
//  Quixpense
//
//  Created by Matt Quiros on 06/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var category: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateSpent: NSDate?
    @NSManaged public var daySectionId: String?
    @NSManaged public var monthSectionId: String?
    @NSManaged public var weekSectionIdMonday: String?
    @NSManaged public var weekSectionIdSaturday: String?
    @NSManaged public var weekSectionIdSunday: String?
    @NSManaged public var tagRefs: NSSet?

}

// MARK: Generated accessors for tagRefs
extension Expense {

    @objc(addTagRefsObject:)
    @NSManaged public func addToTagRefs(_ value: Tag)

    @objc(removeTagRefsObject:)
    @NSManaged public func removeFromTagRefs(_ value: Tag)

    @objc(addTagRefs:)
    @NSManaged public func addToTagRefs(_ values: NSSet)

    @objc(removeTagRefs:)
    @NSManaged public func removeFromTagRefs(_ values: NSSet)

}

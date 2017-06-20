//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
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
    @NSManaged public var dayCategoryGroup: DayCategoryGroup?
    @NSManaged public var dayTagGroups: NSSet?
    @NSManaged public var monthCategoryGroup: MonthCategoryGroup?
    @NSManaged public var monthTagGroups: NSSet?
    @NSManaged public var tags: NSSet?
    @NSManaged public var weekCategoryGroup: WeekCategoryGroup?
    @NSManaged public var weekTagGroups: NSSet?

}

// MARK: Generated accessors for dayTagGroups
extension Expense {

    @objc(addDayTagGroupsObject:)
    @NSManaged public func addToDayTagGroups(_ value: DayTagGroup)

    @objc(removeDayTagGroupsObject:)
    @NSManaged public func removeFromDayTagGroups(_ value: DayTagGroup)

    @objc(addDayTagGroups:)
    @NSManaged public func addToDayTagGroups(_ values: NSSet)

    @objc(removeDayTagGroups:)
    @NSManaged public func removeFromDayTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for monthTagGroups
extension Expense {

    @objc(addMonthTagGroupsObject:)
    @NSManaged public func addToMonthTagGroups(_ value: MonthTagGroup)

    @objc(removeMonthTagGroupsObject:)
    @NSManaged public func removeFromMonthTagGroups(_ value: MonthTagGroup)

    @objc(addMonthTagGroups:)
    @NSManaged public func addToMonthTagGroups(_ values: NSSet)

    @objc(removeMonthTagGroups:)
    @NSManaged public func removeFromMonthTagGroups(_ values: NSSet)

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

// MARK: Generated accessors for weekTagGroups
extension Expense {

    @objc(addWeekTagGroupsObject:)
    @NSManaged public func addToWeekTagGroups(_ value: WeekTagGroup)

    @objc(removeWeekTagGroupsObject:)
    @NSManaged public func removeFromWeekTagGroups(_ value: WeekTagGroup)

    @objc(addWeekTagGroups:)
    @NSManaged public func addToWeekTagGroups(_ values: NSSet)

    @objc(removeWeekTagGroups:)
    @NSManaged public func removeFromWeekTagGroups(_ values: NSSet)

}

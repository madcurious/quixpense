//
//  Expense+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData

extension Expense {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var dateCreated: Date?
    @NSManaged var dateSpent: Date?
    @NSManaged var category: Category?
    @NSManaged var dayCategoryGroup: DayCategoryGroup?
    @NSManaged var dayTagGroups: NSSet?
    @NSManaged var monthCategoryGroup: MonthCategoryGroup?
    @NSManaged var monthTagGroups: NSSet?
    @NSManaged var tags: NSSet?
    @NSManaged var weekCategoryGroup: WeekCategoryGroup?
    @NSManaged var weekTagGroups: NSSet?

}

// MARK: Generated accessors for dayTagGroups
extension Expense {

    @objc(addDayTagGroupsObject:)
    @NSManaged func addToDayTagGroups(_ value: DayTagGroup)

    @objc(removeDayTagGroupsObject:)
    @NSManaged func removeFromDayTagGroups(_ value: DayTagGroup)

    @objc(addDayTagGroups:)
    @NSManaged func addToDayTagGroups(_ values: NSSet)

    @objc(removeDayTagGroups:)
    @NSManaged func removeFromDayTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for monthTagGroups
extension Expense {

    @objc(addMonthTagGroupsObject:)
    @NSManaged func addToMonthTagGroups(_ value: MonthTagGroup)

    @objc(removeMonthTagGroupsObject:)
    @NSManaged func removeFromMonthTagGroups(_ value: MonthTagGroup)

    @objc(addMonthTagGroups:)
    @NSManaged func addToMonthTagGroups(_ values: NSSet)

    @objc(removeMonthTagGroups:)
    @NSManaged func removeFromMonthTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Expense {

    @objc(addTagsObject:)
    @NSManaged func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for weekTagGroups
extension Expense {

    @objc(addWeekTagGroupsObject:)
    @NSManaged func addToWeekTagGroups(_ value: WeekTagGroup)

    @objc(removeWeekTagGroupsObject:)
    @NSManaged func removeFromWeekTagGroups(_ value: WeekTagGroup)

    @objc(addWeekTagGroups:)
    @NSManaged func addToWeekTagGroups(_ values: NSSet)

    @objc(removeWeekTagGroups:)
    @NSManaged func removeFromWeekTagGroups(_ values: NSSet)

}

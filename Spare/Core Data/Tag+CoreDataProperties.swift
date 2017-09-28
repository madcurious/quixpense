//
//  Tag+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged var dayTagGroups: NSSet?
    @NSManaged var monthTagGroups: NSSet?
    @NSManaged var weekTagGroups: NSSet?

}

// MARK: Generated accessors for dayTagGroups
extension Tag {

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
extension Tag {

    @objc(addMonthTagGroupsObject:)
    @NSManaged func addToMonthTagGroups(_ value: MonthTagGroup)

    @objc(removeMonthTagGroupsObject:)
    @NSManaged func removeFromMonthTagGroups(_ value: MonthTagGroup)

    @objc(addMonthTagGroups:)
    @NSManaged func addToMonthTagGroups(_ values: NSSet)

    @objc(removeMonthTagGroups:)
    @NSManaged func removeFromMonthTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for weekTagGroups
extension Tag {

    @objc(addWeekTagGroupsObject:)
    @NSManaged func addToWeekTagGroups(_ value: WeekTagGroup)

    @objc(removeWeekTagGroupsObject:)
    @NSManaged func removeFromWeekTagGroups(_ value: WeekTagGroup)

    @objc(addWeekTagGroups:)
    @NSManaged func addToWeekTagGroups(_ values: NSSet)

    @objc(removeWeekTagGroups:)
    @NSManaged func removeFromWeekTagGroups(_ values: NSSet)

}

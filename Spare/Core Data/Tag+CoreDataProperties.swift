//
//  Tag+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var dayTagGroups: NSSet?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var monthTagGroups: NSSet?
    @NSManaged public var weekTagGroups: NSSet?

}

// MARK: Generated accessors for dayTagGroups
extension Tag {

    @objc(addDayTagGroupsObject:)
    @NSManaged public func addToDayTagGroups(_ value: DayTagGroup)

    @objc(removeDayTagGroupsObject:)
    @NSManaged public func removeFromDayTagGroups(_ value: DayTagGroup)

    @objc(addDayTagGroups:)
    @NSManaged public func addToDayTagGroups(_ values: NSSet)

    @objc(removeDayTagGroups:)
    @NSManaged public func removeFromDayTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for expenses
extension Tag {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for monthTagGroups
extension Tag {

    @objc(addMonthTagGroupsObject:)
    @NSManaged public func addToMonthTagGroups(_ value: MonthTagGroup)

    @objc(removeMonthTagGroupsObject:)
    @NSManaged public func removeFromMonthTagGroups(_ value: MonthTagGroup)

    @objc(addMonthTagGroups:)
    @NSManaged public func addToMonthTagGroups(_ values: NSSet)

    @objc(removeMonthTagGroups:)
    @NSManaged public func removeFromMonthTagGroups(_ values: NSSet)

}

// MARK: Generated accessors for weekTagGroups
extension Tag {

    @objc(addWeekTagGroupsObject:)
    @NSManaged public func addToWeekTagGroups(_ value: WeekTagGroup)

    @objc(removeWeekTagGroupsObject:)
    @NSManaged public func removeFromWeekTagGroups(_ value: WeekTagGroup)

    @objc(addWeekTagGroups:)
    @NSManaged public func addToWeekTagGroups(_ values: NSSet)

    @objc(removeWeekTagGroups:)
    @NSManaged public func removeFromWeekTagGroups(_ values: NSSet)

}

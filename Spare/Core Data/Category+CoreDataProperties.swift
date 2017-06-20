//
//  Category+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 20/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var dayCategoryGroups: NSSet?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var monthCategoryGroups: NSSet?
    @NSManaged public var weekCategoryGroups: NSSet?

}

// MARK: Generated accessors for dayCategoryGroups
extension Category {

    @objc(addDayCategoryGroupsObject:)
    @NSManaged public func addToDayCategoryGroups(_ value: DayCategoryGroup)

    @objc(removeDayCategoryGroupsObject:)
    @NSManaged public func removeFromDayCategoryGroups(_ value: DayCategoryGroup)

    @objc(addDayCategoryGroups:)
    @NSManaged public func addToDayCategoryGroups(_ values: NSSet)

    @objc(removeDayCategoryGroups:)
    @NSManaged public func removeFromDayCategoryGroups(_ values: NSSet)

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

// MARK: Generated accessors for monthCategoryGroups
extension Category {

    @objc(addMonthCategoryGroupsObject:)
    @NSManaged public func addToMonthCategoryGroups(_ value: MonthCategoryGroup)

    @objc(removeMonthCategoryGroupsObject:)
    @NSManaged public func removeFromMonthCategoryGroups(_ value: MonthCategoryGroup)

    @objc(addMonthCategoryGroups:)
    @NSManaged public func addToMonthCategoryGroups(_ values: NSSet)

    @objc(removeMonthCategoryGroups:)
    @NSManaged public func removeFromMonthCategoryGroups(_ values: NSSet)

}

// MARK: Generated accessors for weekCategoryGroups
extension Category {

    @objc(addWeekCategoryGroupsObject:)
    @NSManaged public func addToWeekCategoryGroups(_ value: WeekCategoryGroup)

    @objc(removeWeekCategoryGroupsObject:)
    @NSManaged public func removeFromWeekCategoryGroups(_ value: WeekCategoryGroup)

    @objc(addWeekCategoryGroups:)
    @NSManaged public func addToWeekCategoryGroups(_ values: NSSet)

    @objc(removeWeekCategoryGroups:)
    @NSManaged public func removeFromWeekCategoryGroups(_ values: NSSet)

}

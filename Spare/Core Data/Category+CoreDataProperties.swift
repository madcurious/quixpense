//
//  Category+CoreDataProperties.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged var dayCategoryGroups: NSSet?
    @NSManaged var monthCategoryGroups: NSSet?
    @NSManaged var weekCategoryGroups: NSSet?

}

// MARK: Generated accessors for dayCategoryGroups
extension Category {

    @objc(addDayCategoryGroupsObject:)
    @NSManaged func addToDayCategoryGroups(_ value: DayCategoryGroup)

    @objc(removeDayCategoryGroupsObject:)
    @NSManaged func removeFromDayCategoryGroups(_ value: DayCategoryGroup)

    @objc(addDayCategoryGroups:)
    @NSManaged func addToDayCategoryGroups(_ values: NSSet)

    @objc(removeDayCategoryGroups:)
    @NSManaged func removeFromDayCategoryGroups(_ values: NSSet)

}

// MARK: Generated accessors for monthCategoryGroups
extension Category {

    @objc(addMonthCategoryGroupsObject:)
    @NSManaged func addToMonthCategoryGroups(_ value: MonthCategoryGroup)

    @objc(removeMonthCategoryGroupsObject:)
    @NSManaged func removeFromMonthCategoryGroups(_ value: MonthCategoryGroup)

    @objc(addMonthCategoryGroups:)
    @NSManaged func addToMonthCategoryGroups(_ values: NSSet)

    @objc(removeMonthCategoryGroups:)
    @NSManaged func removeFromMonthCategoryGroups(_ values: NSSet)

}

// MARK: Generated accessors for weekCategoryGroups
extension Category {

    @objc(addWeekCategoryGroupsObject:)
    @NSManaged func addToWeekCategoryGroups(_ value: WeekCategoryGroup)

    @objc(removeWeekCategoryGroupsObject:)
    @NSManaged func removeFromWeekCategoryGroups(_ value: WeekCategoryGroup)

    @objc(addWeekCategoryGroups:)
    @NSManaged func addToWeekCategoryGroups(_ values: NSSet)

    @objc(removeWeekCategoryGroups:)
    @NSManaged func removeFromWeekCategoryGroups(_ values: NSSet)

}

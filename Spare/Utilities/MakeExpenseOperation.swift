//
//  MakeExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 19/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

class MakeExpenseOperation: MDOperation<Expense> {
    
    let context: NSManagedObjectContext
    let amount: NSDecimalNumber
    let dateSpent: Date
    let categoryName: String
    let tagNames: [String]
    
    init(context: NSManagedObjectContext,
         amount: NSDecimalNumber,
         dateSpent: Date,
         categoryName: String?,
         tagNames: [String]?) {
        self.context = context
        self.amount = amount
        self.dateSpent = dateSpent
        
        if let categoryName = categoryName {
            self.categoryName = categoryName
        } else {
            self.categoryName = "Uncategorized"
        }
        
        if let tagNames = tagNames {
            self.tagNames = tagNames
        } else {
            self.tagNames = ["Untagged"]
        }
    }
    
    override func makeResult(from source: Any?) throws -> Expense {
        let newExpense = Expense(context: self.context)
        newExpense.dateCreated = Date()
        newExpense.amount = self.amount
        newExpense.dateSpent = self.dateSpent
        
        let category = try self.makeCategory()
        newExpense.category = category
        
        let tags = try self.makeTags()
        newExpense.addToTags(tags as NSSet)
        
        let dayCategoryGroup = try self.makeClassifierGroup(
            entityName: md_getClassName(DayCategoryGroup.self), classifier: category)
        newExpense.setValue(dayCategoryGroup, forKey: "dayCategoryGroup")
        
        let weekCategoryGroup = try self.makeClassifierGroup(
            entityName: md_getClassName(WeekCategoryGroup.self), classifier: category)
        newExpense.setValue(weekCategoryGroup, forKey: "weekCategoryGroup")
        
        let monthCategoryGroup = try self.makeClassifierGroup(
            entityName: md_getClassName(MonthCategoryGroup.self), classifier: category)
        newExpense.setValue(monthCategoryGroup, forKey: "monthCategoryGroup")
        
        for tag in tags {
            let dayTagGroup = try self.makeClassifierGroup(
                entityName: md_getClassName(DayTagGroup.self), classifier: tag)
            newExpense.addToDayTagGroups(self.context.object(with: dayTagGroup.objectID) as! DayTagGroup)
            
            let weekTagGroup = try self.makeClassifierGroup(
                entityName: md_getClassName(WeekTagGroup.self), classifier: tag)
            newExpense.addToWeekTagGroups(self.context.object(with: weekTagGroup.objectID) as! WeekTagGroup)
            
            let monthTagGroup = try self.makeClassifierGroup(
                entityName: md_getClassName(MonthTagGroup.self), classifier: tag)
            newExpense.addToMonthTagGroups(self.context.object(with: monthTagGroup.objectID) as! MonthTagGroup)
        }
        
        return newExpense
    }
    
    // MARK: - Helper functions
    
    func makeCategory() throws -> Category {
        let categoryFetch: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "%K ==[c] %@", #keyPath(Category.name), self.categoryName)
        
        if let existingCategory = try self.context.fetch(categoryFetch).first {
            return existingCategory
        } else {
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName
            return newCategory
        }
    }
    
    func makeTags() throws -> Set<Tag> {
        var tags = Set<Tag>()
        
        for tagName in self.tagNames {
            let tagFetch: NSFetchRequest<Tag> = Tag.fetchRequest()
            tagFetch.predicate = NSPredicate(format: "%K ==[c] %@", #keyPath(Tag.name), tagName)
            
            if let existingTag = try self.context.fetch(tagFetch).first {
                tags.insert(existingTag)
            } else {
                let newTag = Tag(context: self.context)
                newTag.name = tagName
                tags.insert(newTag)
            }
        }
        
        return tags
    }
    
    func makeClassifierGroup(entityName: String, classifier: NSManagedObject) throws -> NSManagedObject {
        let sectionIdentifier = self.makeSectionIdentifier(for: entityName)
        
        let groupFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                           "sectionIdentifier", sectionIdentifier,
                                           "classifier", classifier
        )
        
        if let existingGroup = try self.context.fetch(groupFetch).first as? NSManagedObject {
            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
            runningTotal += self.amount
            existingGroup.setValue(runningTotal, forKey: "total")
            return existingGroup
        } else {
            // Create an instance of the group managed object.
            // As much as this approach sucks, Core Data crashes if we instantiate
            // a generic NSManagedObject instead and provide the entity name.
            let newGroup: NSManagedObject = {
                switch entityName {
                case md_getClassName(DayCategoryGroup.self):
                    return DayCategoryGroup(context: self.context)
                case md_getClassName(DayTagGroup.self):
                    return DayTagGroup(context: self.context)
                case md_getClassName(WeekCategoryGroup.self):
                    return WeekCategoryGroup(context: self.context)
                case md_getClassName(WeekTagGroup.self):
                    return WeekTagGroup(context: self.context)
                case md_getClassName(MonthCategoryGroup.self):
                    return MonthCategoryGroup(context: self.context)
                case md_getClassName(MonthTagGroup.self):
                    return MonthTagGroup(context: self.context)
                default:
                    fatalError("\(#function) - Attempted to make instance of invalid entityName: \(entityName)")
                }
            }()
            
            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
            newGroup.setValue(self.amount, forKey: "total")
            newGroup.setValue(classifier, forKey: "classifier")
            
            return newGroup
        }
    }
    
    func makeSectionIdentifier(for entityName: String) -> String {
        let startDate: Date
        let endDate: Date
        
        switch entityName {
        case md_getClassName(DayCategoryGroup.self), md_getClassName(DayTagGroup.self):
            startDate = self.dateSpent.startOfDay()
            endDate = self.dateSpent.endOfDay()
            
        case md_getClassName(WeekCategoryGroup.self), md_getClassName(WeekTagGroup.self):
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = self.dateSpent.startOfWeek(firstWeekday: firstWeekday)
            endDate = self.dateSpent.endOfWeek(firstWeekday: firstWeekday)
            
        case md_getClassName(MonthCategoryGroup.self), md_getClassName(MonthTagGroup.self):
            startDate = self.dateSpent.startOfMonth()
            endDate = self.dateSpent.endOfMonth()
            
        default:
            fatalError("\(#function) - Attempted to make section identifier for invalid entityName: \(entityName)")
        }
        
        return SectionIdentifier.make(startDate: startDate, endDate: endDate)
    }
    
}

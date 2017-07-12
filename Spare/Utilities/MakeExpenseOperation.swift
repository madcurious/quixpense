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

public class MakeExpenseOperation: MDOperation<Expense> {
    
    let context: NSManagedObjectContext
    let amount: NSDecimalNumber
    let dateSpent: Date
    let categoryName: String
    let tagNames: [String]
    
    public init(context: NSManagedObjectContext,
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
            self.categoryName = DefaultClassifier.uncategorized.rawValue
        }
        
        if let tagNames = tagNames {
            self.tagNames = tagNames
        } else {
            self.tagNames = [DefaultClassifier.untagged.rawValue]
        }
    }
    
    public override func makeResult(from source: Any?) throws -> Expense {
        let newExpense = Expense(context: self.context)
        newExpense.dateCreated = Date()
        newExpense.amount = self.amount
        newExpense.dateSpent = self.dateSpent
        
        let category = try self.makeCategory()
        newExpense.category = category
        
        let tags = try self.makeTags()
        newExpense.addToTags(tags as NSSet)
        
        let dayCategoryGroup = try self.makeGroup(with: category) as DayCategoryGroup
        newExpense.setValue(dayCategoryGroup, forKey: "dayCategoryGroup")
        
        let weekCategoryGroup = try self.makeGroup(with: category) as WeekCategoryGroup
        newExpense.setValue(weekCategoryGroup, forKey: "weekCategoryGroup")
        
        let monthCategoryGroup = try self.makeGroup(with: category) as MonthCategoryGroup
        newExpense.setValue(monthCategoryGroup, forKey: "monthCategoryGroup")
        
        for tag in tags {
            let dayTagGroup = try self.makeGroup(with: tag) as DayTagGroup
            newExpense.addToDayTagGroups(dayTagGroup)
            
            let weekTagGroup = try self.makeGroup(with: tag) as WeekTagGroup
            newExpense.addToWeekTagGroups(weekTagGroup)
            
            let monthTagGroup = try self.makeGroup(with: tag) as MonthTagGroup
            newExpense.addToMonthTagGroups(monthTagGroup)
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
    
    func makeGroup<T: NSManagedObject>(with classifier: NSManagedObject) throws -> T {
        let className = md_getClassName(T.self)
        let sectionIdentifier = self.makeSectionIdentifier(for: T.self)
        let groupFetch = NSFetchRequest<T>(entityName: className)
        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                           "sectionIdentifier", sectionIdentifier,
                                           "classifier", classifier
        )
        
        if let existingGroup = try self.context.fetch(groupFetch).first {
            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
            runningTotal += self.amount
            existingGroup.setValue(runningTotal, forKey: "total")
            return existingGroup
        } else {
            let newGroup = T(context: self.context)
            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
            newGroup.setValue(self.amount, forKey: "total")
            newGroup.setValue(classifier, forKey: "classifier")
            
            return newGroup
        }
    }
    
    func makeSectionIdentifier(for type: AnyClass) -> String {
        let startDate: Date
        let endDate: Date
        
        if type === DayCategoryGroup.self || type === DayTagGroup.self {
            startDate = self.dateSpent.startOfDay()
            endDate = self.dateSpent.endOfDay()
        } else if type === WeekCategoryGroup.self || type === WeekTagGroup.self {
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = self.dateSpent.startOfWeek(firstWeekday: firstWeekday)
            endDate = self.dateSpent.endOfWeek(firstWeekday: firstWeekday)
        } else {
            startDate = self.dateSpent.startOfMonth()
            endDate = self.dateSpent.endOfMonth()
        }
        
        return SectionIdentifier.make(startDate: startDate, endDate: endDate)
    }
    
}

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
            self.categoryName = "Uncategorized"
        }
        
        if let tagNames = tagNames {
            self.tagNames = tagNames
        } else {
            self.tagNames = ["Untagged"]
        }
    }
    
    public override func makeResult(from source: Any?) throws -> Expense {
        let newExpense = Expense(context: self.context)
        newExpense.dateCreated = Date() as NSDate
        newExpense.amount = self.amount
        newExpense.dateSpent = self.dateSpent as NSDate
        
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
            //            newExpense.addToDayTagGroups(NSSet(objects: self.context.object(with: dayTagGroup.objectID)))
            
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
        let type = ClassifierGroup(className: md_getClassName(T.self))!
        let sectionIdentifier = self.makeSectionIdentifier(for: type)
        let groupFetch = NSFetchRequest<T>(entityName: type.entityName)
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
            // Create an instance of the group managed object.
            // As much as this approach sucks, Core Data crashes if we instantiate
            // a generic NSManagedObject instead and provide the entity name.
            let newGroup: T = {[unowned self] in
                let entityDescription = NSEntityDescription.entity(forEntityName: type.entityName, in: self.context)!
                //                return NSManagedObject(entity: entityDescription, insertInto: self.context)
                return T(entity: entityDescription, insertInto: self.context)
                }()
            
            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
            newGroup.setValue(self.amount, forKey: "total")
            newGroup.setValue(classifier, forKey: "classifier")
            
            return newGroup
        }
    }
    
//    func makeGroup(type: ClassifierGroup, classifier: NSManagedObject) throws -> NSManagedObject {
//        let sectionIdentifier = self.makeSectionIdentifier(for: type)
//
//        let groupFetch = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
//        groupFetch.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
//                                           "sectionIdentifier", sectionIdentifier,
//                                           "classifier", classifier
//        )
//
//        if let existingGroup = try self.context.fetch(groupFetch).first as? NSManagedObject {
//            var runningTotal = existingGroup.value(forKey: "total") as! NSDecimalNumber
//            runningTotal += self.amount
//            existingGroup.setValue(runningTotal, forKey: "total")
//            return existingGroup
//        } else {
//            // Create an instance of the group managed object.
//            // As much as this approach sucks, Core Data crashes if we instantiate
//            // a generic NSManagedObject instead and provide the entity name.
//            let newGroup: NSManagedObject = {[unowned self] in
//                let entityDescription = NSEntityDescription.entity(forEntityName: type.entityName, in: self.context)!
////                return NSManagedObject(entity: entityDescription, insertInto: self.context)
//
//                switch type {
//                case .dayCategoryGroup:
//                    return DayCategoryGroup(entity: entityDescription, insertInto: self.context)
//                case .dayTagGroup:
//                    return DayTagGroup(entity: entityDescription, insertInto: self.context)
//                case .weekCategoryGroup:
//                    return WeekCategoryGroup(entity: entityDescription, insertInto: self.context)
//                case .weekTagGroup:
//                    return WeekTagGroup(entity: entityDescription, insertInto: self.context)
//                case .monthCategoryGroup:
//                    return MonthCategoryGroup(entity: entityDescription, insertInto: self.context)
//                case .monthTagGroup:
//                    return MonthTagGroup(entity: entityDescription, insertInto: self.context)
//                default:
//                    fatalError("\(#function) - Attempted to make instance of invalid entityName: \(type)")
//                }
//            }()
//
//            newGroup.setValue(sectionIdentifier, forKey: "sectionIdentifier")
//            newGroup.setValue(self.amount, forKey: "total")
//            newGroup.setValue(classifier, forKey: "classifier")
//
//            return newGroup
//        }
//    }
        
    func makeSectionIdentifier(for type: ClassifierGroup) -> String {
        let startDate: Date
        let endDate: Date
        
        switch type {
        case .dayCategoryGroup, .dayTagGroup:
            startDate = self.dateSpent.startOfDay()
            endDate = self.dateSpent.endOfDay()
            
        case .weekCategoryGroup, .weekTagGroup:
            let firstWeekday = Global.startOfWeek.rawValue
            startDate = self.dateSpent.startOfWeek(firstWeekday: firstWeekday)
            endDate = self.dateSpent.endOfWeek(firstWeekday: firstWeekday)
            
        case .monthCategoryGroup, .monthTagGroup:
            startDate = self.dateSpent.startOfMonth()
            endDate = self.dateSpent.endOfMonth()
        }
        
        return SectionIdentifier.make(startDate: startDate, endDate: endDate)
    }
    
}

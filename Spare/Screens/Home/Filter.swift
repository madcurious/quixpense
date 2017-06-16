//
//  Filter.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

func ==(lhs: Filter, rhs: Filter) -> Bool {
    return lhs.periodization == rhs.periodization &&
        lhs.grouping == rhs.grouping
}

struct Filter: Equatable {
    
    enum Periodization: Int {
        case day = 0, week, month
        
        func text() -> String {
            switch self {
            case .day:
                return "Daily"
                
            case .week:
                return "Weekly"
                
            case .month:
                return "Monthly"
            }
        }
    }
    
    enum Grouping: Int {
        case category = 0, tag
        
        func text() -> String {
            switch self {
            case .category:
                return "by category"
                
            case .tag:
                return "by tag"
            }
        }
    }
    
    var periodization = Periodization.day
    var grouping = Grouping.category
    
    func text() -> String {
        return "\(self.periodization.text()), \(self.grouping.text())"
    }
    
    func entityName() -> String {
        switch self.periodization{
        case .day:
            return md_getClassName(DayCategoryGroup.self)
            
        case .week:
            return md_getClassName(WeekCategoryGroup.self)
            
        case .month:
            return md_getClassName(MonthCategoryGroup.self)
        }
    }
    
    func makeFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        switch self.grouping {
        case .category:
            return self.makeFetcherForCategory()
            
        case .tag:
            return self.makeFetcherForTags()
        }
    }
    
    private func makeFetcherForCategory() -> NSFetchedResultsController<NSFetchRequestResult> {
        let sectionNameKeyPath: String = {
            switch self.periodization {
            case .day:
                return #keyPath(Expense.daySectionIdentifier)
            case .week:
                switch Global.startOfWeek {
                case .sunday:
                    return #keyPath(Expense.sundayWeekSectionIdentifier)
                case .monday:
                    return #keyPath(Expense.mondayWeekSectionIdentifier)
                case .saturday:
                    return #keyPath(Expense.saturdayWeekSectionIdentifier)
                }
            case .month:
                return #keyPath(Expense.monthSectionIdentifier)
            }
        }()
        
        let classifierKeyPath = #keyPath(Expense.category)
        
        let amountExpression = NSExpression(forKeyPath: #keyPath(Expense.amount))
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [amountExpression])
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "total"
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .decimalAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: md_getClassName(Expense.self))
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Expense.dateSpent), ascending: false)
        ]
        fetchRequest.propertiesToFetch = [
            sectionNameKeyPath,
            sumExpressionDescription,
            classifierKeyPath
        ]
        fetchRequest.propertiesToGroupBy = [
            sectionNameKeyPath,
            classifierKeyPath
        ]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: Global.coreDataStack.viewContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: "CacheName")
    }
    
    private func makeFetcherForTags() -> NSFetchedResultsController<NSFetchRequestResult> {
        let groupEntityName: String = {
            switch self.periodization {
            case .day:
                return md_getClassName(DayTagGroup.self)
            case .week:
                return md_getClassName(WeekTagGroup.self)
            case .month:
                fatalError()
            }
        }()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: groupEntityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "endDate", ascending: false),
            NSSortDescriptor(key: "total", ascending: false)
        ]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: Global.coreDataStack.viewContext,
                                          sectionNameKeyPath: "sectionIdentifier",
                                          cacheName: "CacheName")
    }
    
}

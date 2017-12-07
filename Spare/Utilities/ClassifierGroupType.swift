//
//  ClassifierGroupType.swift
//  Spare
//
//  Created by Matt Quiros on 28/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum ClassifierGroupType {
    
    case dayCategory
    case dayTag
    case weekCategory
    case weekTag
    case monthCategory
    case monthTag
    
    var entityDescription: NSEntityDescription {
        switch self {
        case .dayCategory:
            return DayCategoryGroup.entity()
        case .dayTag:
            return DayTagGroup.entity()
        case .weekCategory:
            return WeekCategoryGroup.entity()
        case .weekTag:
            return WeekTagGroup.entity()
        case .monthCategory:
            return MonthCategoryGroup.entity()
        case .monthTag:
            return MonthTagGroup.entity()
        }
    }
    
    var periodization: Periodization {
        switch self {
        case .dayCategory, .dayTag:
            return .day
        case .weekCategory, .weekTag:
            return .week
        default:
            return .month
        }
    }
    
    var classifierType: ClassifierType {
        switch self {
        case .dayCategory, .weekCategory, .monthCategory:
            return .category
        default:
            return .tag
        }
    }
    
    var expenseKeyPath: String {
        switch self {
        case .dayCategory:
            return #keyPath(Expense.dayCategoryGroup)
        case .dayTag:
            return #keyPath(Expense.dayTagGroups)
        case .weekCategory:
            return #keyPath(Expense.weekCategoryGroup)
        case .weekTag:
            return #keyPath(Expense.weekTagGroups)
        case .monthCategory:
            return #keyPath(Expense.monthCategoryGroup)
        case .monthTag:
            return #keyPath(Expense.monthTagGroups)
        }
    }
    
}

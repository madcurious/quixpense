//
//  ClassifierGroup.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

public enum ClassifierGroup: String {
    
    case dayCategoryGroup
    case dayTagGroup
    
    case weekCategoryGroup
    case weekTagGroup
    
    case monthCategoryGroup
    case monthTagGroup
    
    init?(className: String) {
        switch className {
        case md_getClassName(DayCategoryGroup.self):
            self = .dayCategoryGroup
        case md_getClassName(DayTagGroup.self):
            self = .dayTagGroup
        case md_getClassName(WeekCategoryGroup.self):
            self = .weekCategoryGroup
        case md_getClassName(WeekTagGroup.self):
            self = .weekTagGroup
        case md_getClassName(MonthCategoryGroup.self):
            self = .monthCategoryGroup
        case md_getClassName(MonthTagGroup.self):
            self = .monthTagGroup
        default:
            return nil
        }
    }
    
    var entityName: String {
        switch self {
        case .dayCategoryGroup:
            return md_getClassName(DayCategoryGroup.self)
        case .dayTagGroup:
            return md_getClassName(DayTagGroup.self)
        case .weekCategoryGroup:
            return md_getClassName(WeekCategoryGroup.self)
        case .weekTagGroup:
            return md_getClassName(WeekTagGroup.self)
        case .monthCategoryGroup:
            return md_getClassName(MonthCategoryGroup.self)
        case .monthTagGroup:
            return md_getClassName(MonthTagGroup.self)
        }
    }
    
}

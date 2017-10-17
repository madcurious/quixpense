//
//  Filter.swift
//  Spare
//
//  Created by Matt Quiros on 29/05/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

struct Filter {
    
    var periodization = Periodization.day
    var grouping = Grouping.category
    
    func text() -> String {
        return "\(self.periodization.text()), \(self.grouping.text())"
    }
    
    func makeFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let groupEntityName: String = {
            switch self.periodization {
            case .day:
                if self.grouping == .category {
                    return md_getClassName(DayCategoryGroup.self)
                }
                return md_getClassName(DayTagGroup.self)
                
            case .week:
                if self.grouping == .category {
                    return md_getClassName(WeekCategoryGroup.self)
                }
                return md_getClassName(WeekTagGroup.self)
                
            case .month:
                if self.grouping == .category {
                    return md_getClassName(MonthCategoryGroup.self)
                }
                return md_getClassName(MonthTagGroup.self)
            }
        }()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: groupEntityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "sectionIdentifier", ascending: false),
            NSSortDescriptor(key: "classifier.name", ascending: true)
        ]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: Global.coreDataStack.viewContext,
                                          sectionNameKeyPath: "sectionIdentifier",
                                          cacheName: "CacheName")
    }
    
}

extension Filter: Equatable {
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.periodization == rhs.periodization &&
            lhs.grouping == rhs.grouping
    }
    
}

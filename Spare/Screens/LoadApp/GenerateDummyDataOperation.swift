//
//  GenerateDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 22/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

private let kCategoryNames = [
    "Food and Drinks",
    "Transportation",
    "Grooming",
    "Fitness",
    "Electronics",
    "Vacation"
]

class GenerateDummyDataOperation: MDOperation {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        let categoryIDs = try self.makeCategories()
        
        try self.context.saveToStore()
        
        return categoryIDs
    }
    
    func makeCategories() throws -> [NSManagedObjectID] {
        var categoryIDs = [NSManagedObjectID]()
        
        for categoryName in kCategoryNames {
            let category = Category(context: context)
            category.name = categoryName
            categoryIDs.append(category.objectID)
        }
        
        return categoryIDs
    }
    
    deinit {
        print("Deinit \(self)")
    }
}

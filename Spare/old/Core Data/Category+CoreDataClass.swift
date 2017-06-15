//
//  Category+CoreDataClass.swift
//  Spare
//
//  Created by Matt Quiros on 15/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

public class Category: NSManagedObject {
    
    class func fetchAllInViewContext() -> [Category] {
        return try! self.fetchAll(inContext: App.coreDataStack.viewContext, sortedBy: nil)
    }
    
    class func fetchAllIDsInViewContext() -> [NSManagedObjectID] {
        return try! self.fetchAllIDs(inContext: App.coreDataStack.viewContext)
    }
    
    /**
     Fetches all categories as the `Category` managed object subclass, sorted by most popular first.
     The more expenses there are in a category, the more popular it is.
     */
    class func fetchAll(inContext context: NSManagedObjectContext, sortedBy sortOrder: ((Category, Category) -> Bool)?) throws -> [Category] {
        let request = FetchRequestBuilder<Category>.makeTypedRequest()
        var categories = try context.fetch(request)
        
        if let sortOrder = sortOrder {
            categories.sort(by: sortOrder)
        }
//        categories.sort(by: { return $0.expenses?.count ?? 0 > $1.expenses?.count ?? 0 })
        return categories
    }
    
    class func fetchAllIDs(inContext context: NSManagedObjectContext) throws -> [NSManagedObjectID] {
        return try self.fetchAll(inContext: context, sortedBy: nil).map({ $0.objectID })
    }
    
}

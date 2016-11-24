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
        return try! self.fetchAll(inContext: App.coreDataStack.viewContext)
    }
    
    class func fetchAllIDsInViewContext() -> [NSManagedObjectID] {
        return try! self.fetchAllIDs(inContext: App.coreDataStack.viewContext)
    }
    
    /**
     Fetches all categories as the `Category` managed object subclass, and optionally sorts them
     by most popular first. The more expenses there are in a category, the more popular it is.
     
     By default, `sorted` is `true` since getting the categories as `Category` objects almost always
     means that the order matters. When it doesn't, categories are fetched by ID only.
     */
    class func fetchAll(inContext context: NSManagedObjectContext, sorted: Bool = true) throws -> [Category] {
        let request = FetchRequestBuilder<Category>.makeTypedRequest()
        let categories = try context.fetch(request)
        
        if sorted {
            return categories.sorted(by: { return $0.expenses?.count ?? 0 > $1.expenses?.count ?? 0 })
        } else {
            return categories
        }
    }
    
    class func fetchAllIDs(inContext context: NSManagedObjectContext) throws -> [NSManagedObjectID] {
        return try self.fetchAll(inContext: context, sorted: false).map({ $0.objectID })
    }
    
}

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
    
    class func fetchAll(inContext context: NSManagedObjectContext) throws -> [Category] {
        let request = FetchRequestBuilder<Category>.makeTypedRequest()
        let categories = try context.fetch(request).sorted(by: { return $0.expenses?.count ?? 0 > $1.expenses?.count ?? 0 })
        return categories
    }
    
}

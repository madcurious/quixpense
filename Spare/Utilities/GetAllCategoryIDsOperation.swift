//
//  GetAllCategoryIDsOperation.swift
//  Spare
//
//  Created by Matt Quiros on 21/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class GetAllCategoryIDsOperation: MDOperation {
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = App.coreDataStack.viewContext
        
        let request = FetchRequestBuilder<Category>.makeIDOnlyRequest()
//        let categories = try context.fetch(request).sorted(by: { $0.expenses?.count ?? 0 > $1.expenses?.count ?? 0 })
        let IDs = try context.fetch(request).sorted(by: {id1, id2 in
            guard let left = context.object(with: id1) as? Category,
                let right = context.object(with: id2) as? Category
                else {
                    return false
            }
            
            return left.expenses?.count ?? 0 > right.expenses?.count ?? 0
        })
        return IDs
    }
    
}

//
//  MakeDefaultDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 27/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

class MakeDefaultDataOperation: MDOperation<Any?> {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        let uncategorized = Category(context: self.context)
        uncategorized.name = DefaultClassifier.uncategorized.rawValue
        
        let untagged = Tag(context: self.context)
        untagged.name = DefaultClassifier.untagged.rawValue
        
        try self.context.saveToStore()
        
        return nil
    }
    
}

//
//  MakeDefaultDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 27/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

class MakeDefaultDataOperation: MDOperation {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        self.makeDefaultCategories()
        
        try self.context.saveToStore()
        
        return nil
    }
    
    private func makeDefaultCategories() {
        let uncategorized = Category(context: self.context)
        uncategorized.name = "Uncategorized"
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}

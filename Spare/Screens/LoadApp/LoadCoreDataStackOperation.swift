//
//  LoadCoreDataStackOperation.swift
//  Spare
//
//  Created by Matt Quiros on 31/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

class LoadCoreDataStackOperation: TBAsynchronousOperation<NSPersistentContainer, Error> {
    
    let inMemory: Bool
    
    init(inMemory: Bool, completionBlock: TBOperationCompletionBlock?) {
        self.inMemory = inMemory
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        let persistentContainer = NSPersistentContainer(name: "Spare")
        if self.inMemory,
            let description = persistentContainer.persistentStoreDescriptions.first {
            description.type = NSInMemoryStoreType
        }
        
        persistentContainer.loadPersistentStores() { [unowned self] (_, error) in
            defer {
                self.finish()
            }
            
            if self.isCancelled {
                return
            }
            
            if let error = error {
                self.result = .error(error)
            } else {
                self.result = .success(persistentContainer)
            }
        }
    }
    
}

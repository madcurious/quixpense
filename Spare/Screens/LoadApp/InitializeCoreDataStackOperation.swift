//
//  InitializeCoreDataStackOperation.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Mold
import CoreData

class InitializeCoreDataStackOperation: MDAsynchronousOperation<NSPersistentContainer> {
    
    let inMemory: Bool
    
    init(inMemory: Bool) {
        self.inMemory = inMemory
        super.init()
    }
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.finish()
            return
        }
        
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
                self.error = error
                self.runFailureBlock(error: error)
                self.finish()
            } else {
                self.result = persistentContainer
                self.runSuccessBlock(result: persistentContainer)
                self.finish()
            }
        }
    }
    
}

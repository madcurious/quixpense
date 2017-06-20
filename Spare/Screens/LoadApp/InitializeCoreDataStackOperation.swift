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
    
    let dataModelName: String
    let inMemory: Bool
    
    init(dataModelName: String, inMemory: Bool) {
        self.dataModelName = dataModelName
        self.inMemory = inMemory
        super.init()
    }
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.finish()
            return
        }
        
        let persistentContainer = NSPersistentContainer(name: self.dataModelName)
        
        if self.inMemory,
            let description = persistentContainer.persistentStoreDescriptions.first {
            description.type = NSInMemoryStoreType
        }
        
        persistentContainer.loadPersistentStores(completionHandler: {[unowned self] (persistentStoreDescriptions, error) in
            defer {
                self.finish()
            }
            
            if self.isCancelled {
                return
            }
            
            if let error = error {
                self.error = error
                self.runFailureBlock(error: error)
            } else {
                self.result = persistentContainer
                self.runSuccessBlock(result: persistentContainer)
            }
        })
    }
    
}

//
//  InitializeCoreDataStackOperation.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Mold
import CoreData

class InitializeCoreDataStackOperation: MDAsynchronousOperation {
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.finish()
            return
        }
        
        let persistentContainer = NSPersistentContainer(name: "Spare")
        persistentContainer.loadPersistentStores(completionHandler: {[unowned self] (_, error) in
            defer {
                self.finish()
            }
            
            if self.isCancelled {
                return
            }
            
            if let error = error {
                self.runReturnBlock()
                self.runFailureBlock(error: error)
            } else {
                self.runReturnBlock()
                self.runSuccessBlock(result: persistentContainer)
            }
        })
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}

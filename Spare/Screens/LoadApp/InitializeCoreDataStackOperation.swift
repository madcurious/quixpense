//
//  InitializeCoreDataStackOperation.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Mold
import CoreData

class InitializeCoreDataStackOperation: MDOperation {
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.closeOperation()
            return
        }
        
        let persistentContainer = NSPersistentContainer(name: "Spare")
        persistentContainer.loadPersistentStores(completionHandler: {[unowned self] (_, error) in
            defer {
                self.closeOperation()
            }
            
            if let error = error {
                self.runFailBlock(error)
                return
            }
            self.runSuccessBlock(persistentContainer)
        })
    }
    
}

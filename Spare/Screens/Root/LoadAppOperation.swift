//
//  LoadAppOperation.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class LoadAppOperation: MDOperation {
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.closeOperation()
            return
        }
        
        let stack = NSPersistentContainer(name: "Spare")
        stack.loadPersistentStores(completionHandler: {[unowned self] (_, error) in
            defer {
                self.closeOperation()
            }
            
            if let error = error {
                self.runFailBlock(error)
                return
            }
            self.runSuccessBlock(stack)
        })
    }
    
}

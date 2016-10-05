//
//  LoadAppOperation.swift
//  Spare
//
//  Created by Matt Quiros on 25/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import BNRCoreDataStack

class LoadAppOperation: MDOperation {
    
    override func main() {
        self.runStartBlock()
        
        if self.isCancelled {
            self.closeOperation()
            return
        }
        
        // Initialise CoreData stack.
        CoreDataStack.constructSQLiteStack(modelName: "Spare") {[unowned self] (result) in
            defer {
                self.closeOperation()
            }
            
            if self.isCancelled {
                return
            }
            
            switch result {
            case .success(let stack):
                self.runSuccessBlock(stack)
                
            case .failure(let error):
                self.runFailBlock(error)
            }
        }
    }
    
}

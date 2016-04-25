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
        
        if self.cancelled {
            self.closeOperation()
            return
        }
        
        // Initialise CoreData stack.
        CoreDataStack.constructSQLiteStack(withModelName: "Spare") {[unowned self] (result) in
            defer {
                self.closeOperation()
            }
            
            if self.cancelled {
                return
            }
            
            switch result {
            case .Success(let stack):
                self.runSuccessBlock(stack)
                
            case .Failure(let error):
                self.runFailBlock(error)
            }
        }
    }
    
}
//
//  App.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack

private let kSharedInstance = App()

class App {
    
    class var instance: App {
        return kSharedInstance
    }
    
    var coreDataStack: CoreDataStack!
    
    private init() {
        // Initialise CoreData stack.
        CoreDataStack.constructSQLiteStack(withModelName: "Spare") {[unowned self] (result) in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                
            case .Failure(let error as NSError):
                fatalError(error.description)
                
            default:
                fatalError("Unknown error occurred instantiating the Core Data stack.")
            }
        }
    }
    
}
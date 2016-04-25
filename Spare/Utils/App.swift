//
//  App.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack

private let kSharedState = App()

class App {
    
    class var state: App {
        return kSharedState
    }
    
    var coreDataStack: CoreDataStack!
    var mainQueueContext: NSManagedObjectContext {
        return self.coreDataStack.mainQueueContext
    }
    
    private init() {}
    
}
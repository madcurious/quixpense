//
//  SetupApp.swift
//  Quixpense
//
//  Created by Matt Quiros on 21/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock
import CoreData

class SetupApp: BROperation<NSPersistentContainer, Error> {
    
    let queue = OperationQueue()
    var updateBlock: ((String) -> Void)?
    
    init(updateBlock: ((String) -> Void)?, completionBlock: BROperationCompletionBlock?) {
        self.updateBlock = updateBlock
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        // Load the persistent container.
        updateBlock?("Loading the database")
        let loadOp = BRLoadPersistentContainer(documentName: "Model", inMemory: false, completionBlock: nil)
        queue.addOperations([loadOp], waitUntilFinished: true)
        
        if isCancelled {
            return
        }
        
        guard let loadResult = loadOp.result
            else {
                result = .error(BRError("Failed to load the database."))
                return
        }
        switch loadResult {
        case .error(let error):
            result = .error(error)
            
        case .success(let container):
            // Generate dummy data
            let generateOp = GenerateDummy(context: container.newBackgroundContext(), completionBlock: nil)
            queue.addOperations([generateOp], waitUntilFinished: true)
            
            let defaults = UserDefaults.standard
            let lastTimeZone = defaults.string(forKey: DefaultsKey.lastSeenTimeZone.rawValue)
            if lastTimeZone == nil || lastTimeZone != TimeZone.current.identifier {
                // Recompute section identifiers for all expenses.
                updateBlock?("Updating date groups for new time zone")
            }
            
            // Keep track of the last seen time zone so that we can determine
            // whether section identifiers need to be recomputed.
            defaults.set(TimeZone.current.identifier, forKey: DefaultsKey.lastSeenTimeZone.rawValue)
            defaults.synchronize()
            
            result = .success(container)
        }
    }
    
}

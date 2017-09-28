//
//  CoreDataStack.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack: NSObject {
    
    public let persistentContainer: NSPersistentContainer
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
//        viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        viewContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveNotification(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    @objc public func handleSaveNotification(notification: Notification) {
        guard notification.name == Notification.Name.NSManagedObjectContextDidSave,
            let savedContext = notification.object as? NSManagedObjectContext,
            savedContext.parent == nil // Only listen to save notifications from root parent contexts.
            else {
                return
        }
        
        viewContext.mergeChanges(fromContextDidSave: notification)
    }
    
}


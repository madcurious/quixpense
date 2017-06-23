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
    
    public let CoreDataStackDidFinishMergingChanges = Notification.Name.init("CoreDataStackDidFinishMergingChanges")
    
    public let persistentContainer: NSPersistentContainer
    public let viewContext: NSManagedObjectContext
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        self.viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.viewContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveNotification(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }
    
    @objc public func handleSaveNotification(notification: Notification) {
        guard notification.name == Notification.Name.NSManagedObjectContextDidSave,
            let savedContext = notification.object as? NSManagedObjectContext,
            savedContext.parent == nil
            else {
                return
        }
        
        self.viewContext.mergeChanges(fromContextDidSave: notification)
        NotificationCenter.default.post(name: CoreDataStackDidFinishMergingChanges, object: nil)
    }
    
}


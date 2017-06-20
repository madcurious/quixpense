//
//  CoreDataStack.swift
//  Spare
//
//  Created by Matt Quiros on 21/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    let CoreDataStackDidFinishMergingChanges = Notification.Name.init("CoreDataStackDidFinishMergingChanges")
    
    let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        
        self.viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.viewContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveNotification(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }
    
    @objc func handleSaveNotification(notification: Notification) {
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


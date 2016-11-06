//
//  CategoryProvider.swift
//  Spare
//
//  Created by Matt Quiros on 06/11/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

fileprivate let kSharedInstance = CategoryProvider()

class CategoryProvider {
    
    public static var allCategories: [Category] = kSharedInstance.allCategories
    
    private let operationQueue = OperationQueue()
    private var allCategories = [Category]()
    
    fileprivate init() {
        let system = NotificationCenter.default
        system.addObserver(self, selector: #selector(handleUpdateOnMainContext(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: App.coreDataStack.viewContext)
        
        self.runOperation()
    }
    
    @objc private func handleUpdateOnMainContext(notification: Notification) {
        // Check if any of the inserted, updated, or deleted objects is a Category.
        // If so, then re-run the get operation.
        
        let keys = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey]
        for key in keys {
            if let objects = notification.userInfo?[key] as? [NSManagedObject],
                objects.contains(where: { $0 is Category }) {
                self.runOperation()
                break
            }
        }
    }
    
    private func runOperation() {
        self.operationQueue.addOperation(
            GetAllCategoriesOperation()
                .onSuccess({[unowned self] result in
                    self.allCategories = result as! [Category]
                })
        )
    }
    
}

fileprivate class GetAllCategoriesOperation: MDOperation {
    
    fileprivate override func makeResult(fromSource source: Any?) throws -> Any? {
        let context = App.coreDataStack.viewContext
        let request = FetchRequestBuilder<Category>.makeFetchRequest()
        request.resultType = .
        
        let countExpression = NSExpressionDescription()
        countExpression.name = "count"
        countExpression.expression = NSExpression(forKeyPath: "@count.expenses")
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "expenses.count", ascending: false)]
        let categories = try context.fetch(request)
        return categories
    }
    
}

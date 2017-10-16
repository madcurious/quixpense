//
//  LoadCoreDataStackOperation.swift
//  Spare
//
//  Created by Matt Quiros on 31/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

class LoadCoreDataStackOperation: TBAsynchronousOperation<NSPersistentContainer, Error> {
    
    let inMemory: Bool
    
    init(inMemory: Bool, completionBlock: TBOperationCompletionBlock?) {
        self.inMemory = inMemory
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        let persistentContainer = NSPersistentContainer(name: "Spare")
        if self.inMemory,
            let description = persistentContainer.persistentStoreDescriptions.first {
            description.type = NSInMemoryStoreType
        }
        
        persistentContainer.loadPersistentStores() { [unowned self] (_, error) in
            defer {
                self.finish()
            }
            
            if self.isCancelled {
                return
            }
            
            if let error = error {
                self.result = .error(error)
            }
            
            // Generate the default classifiers, if not yet existing.
            let context = persistentContainer.newBackgroundContext()
            let categoryFetch: NSFetchRequest<Category> = Category.fetchRequest()
            categoryFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), DefaultClassifier.noCategory.classifierName)
            let tagFetch: NSFetchRequest<Tag> = Tag.fetchRequest()
            tagFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), DefaultClassifier.noTags.classifierName)
            do {
                if try context.fetch(categoryFetch).first == nil {
                    let defaultCategory = Category(context: context)
                    defaultCategory.name = DefaultClassifier.noCategory.classifierName
                }
                
                if try context.fetch(tagFetch).first == nil {
                    let defaultTag = Tag(context: context)
                    defaultTag.name = DefaultClassifier.noTags.classifierName
                }
                
                try context.saveToStore()
            } catch {
                self.result = .error(error)
                return
            }
            
            self.result = .success(persistentContainer)
        }
    }
    
}

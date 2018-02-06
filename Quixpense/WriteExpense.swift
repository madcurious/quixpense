//
//  WriteExpense.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

/**
 Adds an expense or edits an existing one with a given `NSManagedObjectID`.
 */
class WriteExpense: BROperation<NSManagedObjectID, Error> {
    
    let context: NSManagedObjectContext
    let data: ValidExpense
    let objectId: NSManagedObjectID?
    let shouldSave: Bool
    
    init(context: NSManagedObjectContext, data: ValidExpense, objectId: NSManagedObjectID?, shouldSave: Bool, completion: BROperationCompletionBlock?) {
        self.context = context
        self.data = data
        self.objectId = objectId
        self.shouldSave = shouldSave
        super.init(completionBlock: completion)
    }
    
    override func main() {
        do {
            let expense: Expense
            if let objectId = objectId,
                let existing = context.object(with: objectId) as? Expense {
                expense = existing
            } else {
                expense = Expense(context: context)
                expense.dateCreated = Date() as NSDate
            }
            
            expense.amount = data.amount
            expense.dateSpent = data.dateSpent as NSDate
            expense.category = data.category
            
            for (key, value) in SectionIdentifier.makeAll(for: data.dateSpent) {
                expense.setValue(value, forKey: key)
            }
            
            // Reset the tag references.
            expense.removeAllTagsAndMarkEmptyTagsForDeletion()
            for name in data.tags {
                // Find an existing tag, or make a new one.
                let tag: Tag = try {
                    let tagFetch: NSFetchRequest<Tag> = Tag.fetchRequest()
                    tagFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), name)
                    if let existingTag = try context.fetch(tagFetch).first {
                        return existingTag
                    } else {
                        let newTag = Tag(context: context)
                        newTag.name = name
                        return newTag
                    }
                }()
                expense.addToTags(tag)
            }
            
            if shouldSave == true {
                try context.saveToStore()
            }
            result = .success(expense.objectID)
        } catch {
            result = .error(error)
        }
    }
    
}

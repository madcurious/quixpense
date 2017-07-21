//
//  DefaultClassifier.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum DefaultClassifier: String {
    case uncategorized = "Uncategorized"
    case untagged = "Untagged"
    
    func fetch(in context: NSManagedObjectContext) throws -> NSManagedObject? {
        switch self {
        case .uncategorized:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Category.name), self.rawValue)
            return try context.fetch(fetchRequest).first
            
        case .untagged:
            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.name), self.rawValue)
            return try context.fetch(fetchRequest).first
        }
    }
    
}

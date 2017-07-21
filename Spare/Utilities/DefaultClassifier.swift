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
    
    func fetch<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest = NSFetchRequest<T>()
        fetchRequest.entity = T.entity()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", self.rawValue)
        return try context.fetch(fetchRequest).first
    }
    
}

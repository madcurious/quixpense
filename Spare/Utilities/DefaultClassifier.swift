//
//  DefaultClassifier.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

enum DefaultClassifier {
    case uncategorized
    case untagged
    
    var name: String {
        switch self {
        case .uncategorized:
            return "Uncategorized"
        case .untagged:
            return "Untagged"
        }
    }
    
//    func fetch(in context: NSManagedObjectContext) throws -> NSManagedObject? {
////        let fetchRequest = NSFetchRequest<T>()
////        fetchRequest.entity = {
////            let entityDescription = NSEntityDescription()
////            entityDescription.name = md_getClassName(T.self)
////            return entityDescription
////        }()
////        fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", self.rawValue)
////        return try context.fetch(fetchRequest).first
//        switch self {
//        case .uncategorized:
//            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", name)
//            return try context.fetch(fetchRequest).first
//
//        case .untagged:
//            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", name)
//            return try context.fetch(fetchRequest).first
//        }
//    }
    
    func fetch<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T? {
        switch self {
        case .uncategorized:
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", name)
            return try context.fetch(fetchRequest).first as? T
        case .untagged:
            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "name", name)
            return try context.fetch(fetchRequest).first as? T
        }
    }
    
}

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
    
    case noCategory
    case noTags
    
    var classifierName: String {
        switch self {
        case .noCategory:
            return "No category"
        case .noTags:
            return "No tags"
        }
    }
    
    func fetch<T: Classifier>(in context: NSManagedObjectContext) -> T {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: md_getClassName(T.self))
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Classifier.name), classifierName)
        return try! context.fetch(fetchRequest).first!
    }
    
}

//
//  ObjectGraph.swift
//  Spare
//
//  Created by Matt Quiros on 28/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

final class ObjectGraph {
    
    class func classifier(named name: String, type: ClassifierType, in context: NSManagedObjectContext) throws -> NSManagedObject? {
        let entityDescription = type == .category ? Category.entity() : Tag.entity()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityDescription.name!)
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(Classifier.name), name
        )
        return try context.fetch(fetchRequest).first
    }
    
    class func classifierGroup(ofType type: ClassifierGroupType, classifierName: String, referenceDate: Date, in context: NSManagedObjectContext) throws -> NSManagedObject? {
        let entityDescription = type.entityDescription
        let sectionIdentifier = SectionIdentifier.make(referenceDate: referenceDate, periodization: type.periodization)
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: entityDescription.name!)
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(ClassifierGroup.sectionIdentifier), sectionIdentifier,
                                             #keyPath(ClassifierGroup.classifier.name), classifierName
        )
        return try context.fetch(fetchRequest).first
    }
    
}

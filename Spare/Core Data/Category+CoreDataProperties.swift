//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Matt Quiros on 27/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var colorHex: NSNumber?
    @NSManaged var name: String?
    @NSManaged var expenses: NSSet?

}

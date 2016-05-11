//
//  Summary+CoreDataProperties.swift
//  
//
//  Created by Matt Quiros on 11/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Summary {

    @NSManaged var startDate: NSDate?
    @NSManaged var endDate: NSDate?

}

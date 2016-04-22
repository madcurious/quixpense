//
//  Category.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Category: CoreDataModelable {
    
    static var entityName: String {
        return "Category"
    }
    
}
//
//  CategorySelection.swift
//  Spare
//
//  Created by Matt Quiros on 21/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum CategorySelection: Equatable {
    
    /// A `Category` that already exists. The associated value is that category's `objectID`.
    case id(NSManagedObjectID)
    
    /// A user-entered category name, interpreted as a user's intention to create a new category with
    /// the supplied name in the associated value.
    case name(String)
    
    /// No category selected; and therefore, the default `Uncategorized` category will be assigned.
    case none
    
    static func ==(lhs: CategorySelection, rhs: CategorySelection) -> Bool {
        switch (lhs, rhs) {
        case (.id(let id1), .id(let id2)) where id1 == id2:
            return true
        case (.name(let name1), .name(let name2)) where name1 == name2:
            return true
        case (.none, .none):
            return true
        default:
            return false
        }
    }
    
}

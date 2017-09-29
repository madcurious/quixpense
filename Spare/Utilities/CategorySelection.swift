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
    
    /**
     An existing `Category` and its `objectID`.
     */
    case existing(NSManagedObjectID)
    
    /**
     A new category with a provided name.
     */
    case new(String)
    
    /**
     No category selection, which defaults to the `Category` with a name of `Uncategorized`.
     */
    case none
    
    static func ==(lhs: CategorySelection, rhs: CategorySelection) -> Bool {
        switch (lhs, rhs) {
        case (.existing(let id1), .existing(let id2)) where id1 == id2:
            return true
        case (.new(let name1), .new(let name2)) where name1 == name2:
            return true
        case (.none, .none):
            return true
        default:
            return false
        }
    }
    
}

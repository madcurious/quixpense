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
    
    case id(NSManagedObjectID)
    case name(String)
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

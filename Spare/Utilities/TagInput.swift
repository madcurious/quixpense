//
//  TagInput.swift
//  Spare
//
//  Created by Matt Quiros on 21/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum TagInput: Hashable {
    case id(NSManagedObjectID)
    case name(String)
    
    var hashValue: Int {
        switch self {
        case .id(let objectID):
            return objectID.hashValue
        case .name(let tagName):
            return tagName.hashValue
        }
    }
    
    static func ==(lhs: TagInput, rhs: TagInput) -> Bool {
        switch (lhs, rhs) {
        case (.id(let objectID1), .id(let objectID2)) where objectID1 == objectID2:
            return true
        case (.name(let name1), .name(let name2)) where name1 == name2:
            return true
        default:
            return false
        }
    }
    
}

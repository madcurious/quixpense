//
//  TagSelection.swift
//  Spare
//
//  Created by Matt Quiros on 21/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum TagSelection: Equatable {
    
    enum Member: Hashable {
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
        
        static func ==(lhs: TagSelection.Member, rhs: TagSelection.Member) -> Bool {
            switch (lhs, rhs) {
            case (.id(let id1), .id(let id2)) where id1 == id2:
                return true
            case (.name(let name1), .name(let name2)) where name1 == name2:
                return true
            default:
                return false
            }
        }
    }
    
    case none
    case list([TagSelection.Member])
    
    init(from set: NSSet) {
        let tagSet = set.flatMap({ $0 as? Tag })
        guard tagSet.isEmpty == false
            else {
                self = .none
                return
        }
        var memberList = [TagSelection.Member]()
        for tag in tagSet {
            memberList.append(.id(tag.objectID))
        }
        self = .list(memberList)
    }
    
    static func ==(lhs: TagSelection, rhs: TagSelection) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.list(let list1), .list(let list2)) where list1 == list2:
            return true
        default:
            return false
        }
    }
    
}

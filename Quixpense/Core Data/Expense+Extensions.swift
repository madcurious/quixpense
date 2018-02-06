//
//  Expense+Extensions.swift
//  Quixpense
//
//  Created by Matt Quiros on 06/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

extension Expense {
    
    var tagNames: [String]? {
        return (tags as? Set<Tag>)?.flatMap({ $0.name })
    }
    
    /**
     Removes the expense from all of its tags. Except for the default tag, tags that become empty
     due to the removal are marked for deletion in the expense's context.
     */
    func removeAllTagsAndMarkEmptyTagsForDeletion() {
        guard let tags = tags as? Set<Tag>
            else {
                return
        }
        for tag in tags {
            removeFromTags(tag)
            if tag.name != Classifier.tag.default && (tag.expenses == nil || tag.expenses?.count == 0) {
                managedObjectContext?.delete(tag)
            }
        }
    }
    
}

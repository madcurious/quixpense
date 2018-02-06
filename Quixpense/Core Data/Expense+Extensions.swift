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
        return (tagRefs as? Set<Tag>)?.flatMap({ $0.name })
    }
    
}

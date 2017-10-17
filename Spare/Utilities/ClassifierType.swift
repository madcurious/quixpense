//
//  ClassifierType.swift
//  Spare
//
//  Created by Matt Quiros on 28/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock

enum ClassifierType {
    
    case category, tag
    
    var description: String {
        switch self {
        case .category:
            return "category"
        case .tag:
            return "tag"
        }
    }
    
    func entityName() -> String {
        switch self {
        case .category:
            return md_getClassName(Category.self)
        case .tag:
            return md_getClassName(Tag.self)
        }
    }
    
}

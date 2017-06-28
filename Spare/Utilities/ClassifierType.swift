//
//  ClassifierType.swift
//  Spare
//
//  Created by Matt Quiros on 28/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

enum ClassifierType {
    
    case category, tag
    
    func entityName() -> String {
        switch self {
        case .category:
            return md_getClassName(Category.self)
        case .tag:
            return md_getClassName(Tag.self)
        }
    }
    
}

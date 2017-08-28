//
//  Grouping.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation

enum Grouping: Int {
    
    case category = 0, tag
    
    func text() -> String {
        switch self {
        case .category:
            return "by category"
            
        case .tag:
            return "by tag"
        }
    }
    
}

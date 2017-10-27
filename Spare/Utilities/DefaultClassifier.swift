//
//  DefaultClassifier.swift
//  Spare
//
//  Created by Matt Quiros on 12/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

enum DefaultClassifier {
    
    case noCategory
    case noTags
    
    var classifierName: String {
        switch self {
        case .noCategory:
            return "No category"
        case .noTags:
            return "No tags"
        }
    }
    
}

//
//  DefaultClassifier.swift
//  Quixpense
//
//  Created by Matt Quiros on 08/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation

enum DefaultClassifier {
    
    case category, tag
    
    /// The name stored in Core Data.
    var storedName: String {
        return "__default__"
    }
    
    /// The name displayed in a picker.
    var pickerName: String {
        return "None"
    }
    
    /// The name displayed in the home screen.
    var groupName: String {
        if self == .category {
            return "(no category)"
        }
        return "(no tags)"
    }
    
}

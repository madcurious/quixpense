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
//        return "__default__"
			if self == .category {
				return "__noCat"
			}
			return "__noTags"
    }
    
    /// The name displayed in a picker.
    var optionName: String {
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

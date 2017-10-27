//
//  ClassifierSelection.swift
//  Spare
//
//  Created by Matt Quiros on 27/10/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum ClassifierSelection {
    
    /**
     An existing classifier with the specified `NSManagedObjectID`.
     */
    case id(NSManagedObjectID)
    
    /**
     A classifier that may or may not exist with the specified name as a `String`.
     */
    case name(String)
    
}

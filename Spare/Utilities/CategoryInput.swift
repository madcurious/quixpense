//
//  CategoryInput.swift
//  Spare
//
//  Created by Matt Quiros on 21/07/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

enum CategoryInput {
    case id(NSManagedObjectID)
    case name(String)
    case none
}

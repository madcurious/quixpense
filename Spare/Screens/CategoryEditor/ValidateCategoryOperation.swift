//
//  ValidateCategoryOperation.swift
//  Spare
//
//  Created by Matt Quiros on 10/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Mold

class ValidateCategoryOperation: MDOperation {
    
    var categoryName: String?
    var colorHex: NSNumber?
    
    init(category: Category) {
        self.categoryName = category.name
        self.colorHex = category.colorHex
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        if md_nonEmptyString(self.categoryName) == nil {
            throw Error.UserEnteredInvalidValue("You must enter a category name.")
        }
        
        if self.colorHex == nil {
            throw Error.UserEnteredInvalidValue("You must select a color.")
        }
        
        return nil
    }
    
}
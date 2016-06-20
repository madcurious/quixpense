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
    
    init(category: Category) {
        self.categoryName = category.name
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        guard let _ = md_nonEmptyString(self.categoryName)
            else {
                throw Error.UserEnteredInvalidValue("You must enter a category name.")
        }
        return nil
    }
    
}
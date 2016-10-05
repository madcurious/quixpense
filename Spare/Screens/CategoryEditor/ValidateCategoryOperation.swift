//
//  ValidateCategoryOperation.swift
//  Spare
//
//  Created by Matt Quiros on 10/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Mold

enum ValidateCategoryOperationError: MDErrorType {
    case missingName, missingColor
    
    func object() -> MDError {
        switch self {
        case .missingName:
            return MDError("You must enter a category name.")
            
        case .missingColor:
            return MDError("You must select a color.")
        }
    }
}

class ValidateCategoryOperation: MDOperation {
    
    var categoryName: String?
    var colorHex: NSNumber?
    
    init(category: Category) {
        self.categoryName = category.name
        self.colorHex = category.colorHex
    }
    
    override func makeResult(_ object: Any?) throws -> Any? {
        if md_nonEmptyString(self.categoryName) == nil {
            throw ValidateCategoryOperationError.missingName
        }
        
        if self.colorHex == nil {
            throw ValidateCategoryOperationError.missingColor
        }
        
        return nil
    }
    
}

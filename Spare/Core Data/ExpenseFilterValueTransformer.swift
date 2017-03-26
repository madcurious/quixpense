//
//  ExpenseFilterValueTransformer.swift
//  Spare
//
//  Created by Matt Quiros on 26/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

class ExpenseFilterValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let originalArray = value as? NSArray
            else {
                return nil
        }
        return NSKeyedArchiver.archivedData(withRootObject: originalArray)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData as? Data
            else {
                return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    
}

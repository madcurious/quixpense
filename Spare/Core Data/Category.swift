//
//  Category.swift
//  Spare
//
//  Created by Matt Quiros on 22/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    var color: UIColor {
        guard let colorHex = self.colorHex as? Int
            else {
                return UIColor.blackColor()
        }
        return UIColor(hex: colorHex)
    }

}

extension Category: CoreDataModelable {
    
    static var entityName: String {
        return "Category"
    }
    
}
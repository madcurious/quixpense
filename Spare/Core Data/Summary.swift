//
//  Summary.swift
//  
//
//  Created by Matt Quiros on 11/05/2016.
//
//

import Foundation
import CoreData
import BNRCoreDataStack


class Summary: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}


extension Summary: CoreDataModelable {
    
    static var entityName: String {
        return "Summary"
    }
    
}
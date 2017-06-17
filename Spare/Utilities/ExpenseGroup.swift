//
//  ExpenseGroup.swift
//  Spare
//
//  Created by Matt Quiros on 16/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Mold

enum ExpenseGroup {
    
    case category([String : AnyObject])
    case tag(NSManagedObject)
    
    private static var categorySectionNameKeyPaths: [String] = {
        return [
            #keyPath(Expense.daySectionIdentifier),
            #keyPath(Expense.sundayWeekSectionIdentifier),
            #keyPath(Expense.mondayWeekSectionIdentifier),
            #keyPath(Expense.saturdayWeekSectionIdentifier),
            #keyPath(Expense.monthSectionIdentifier)
        ]
    }()
    
    var classifier: NSManagedObject {
        switch self {
        case .category(let dict):
            let managedObjectID = dict["categoryID"] as! NSManagedObjectID
            return Global.coreDataStack.viewContext.object(with: managedObjectID)
            
        case .tag(let managedObject):
            return managedObject.value(forKey: "classifier") as! NSManagedObject
        }
    }
    
    var groupName: String {
        return self.classifier.value(forKey: "name") as! String
    }
    
    var sectionIdentifier: (keyPath: String, value: String) {
        switch self {
        case .category(let dict):
            let sectionNameKeyPaths = ExpenseGroup.categorySectionNameKeyPaths
            let availableKeyPath = Set<String>(dict.keys).intersection(sectionNameKeyPaths).first!
            let sectionIdentifier = dict[availableKeyPath] as! String
            return (availableKeyPath, sectionIdentifier)
            
        case .tag(let managedObject):
            let sectionIdentifier = managedObject.value(forKey: "sectionIdentifier") as! String
            return ("sectionIdentifier", sectionIdentifier)
        }
    }
    
    var total: NSDecimalNumber {
        switch self {
        case .category(let dict):
            let total = dict["total"] as! NSDecimalNumber
            return total
            
        case .tag(let managedObject):
            let total = managedObject.value(forKey: "total") as! NSDecimalNumber
            return total
        }
    }
    
    init?(from object: Any) {
        if let dict = object as? [String : AnyObject] {
            self = .category(dict)
        } else if let managedObject = object as? NSManagedObject {
            self = .tag(managedObject)
        } else {
            return nil
        }
    }
    
}

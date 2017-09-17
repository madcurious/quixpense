//
//  ClassifierGroup.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

class ClassifierGroup: NSManagedObject {
    
    @NSManaged public var sectionIdentifier: String?
    @NSManaged public var total: NSDecimalNumber?
    @NSManaged public var classifier: Classifier?
    @NSManaged public var expenses: NSSet?
    
}

// MARK: - Accessors for expenses

extension ClassifierGroup {
    
    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)
    
    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)
    
    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)
    
    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)
    
}

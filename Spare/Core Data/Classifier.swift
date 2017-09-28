//
//  Classifier.swift
//  Spare
//
//  Created by Matt Quiros on 17/09/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData

class Classifier: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var expenses: NSSet?
    
}

// MARK: - Accessors for expenses

extension Classifier {
    
    @objc(addExpensesObject:)
    @NSManaged func addToExpenses(_ value: Expense)
    
    @objc(removeExpensesObject:)
    @NSManaged func removeFromExpenses(_ value: Expense)
    
    @objc(addExpenses:)
    @NSManaged func addToExpenses(_ values: NSSet)
    
    @objc(removeExpenses:)
    @NSManaged func removeFromExpenses(_ values: NSSet)
    
}
